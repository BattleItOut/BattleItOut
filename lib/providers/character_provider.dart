import 'package:battle_it_out/persistence/attribute.dart';
import 'package:battle_it_out/persistence/character.dart';
import 'package:battle_it_out/persistence/item/armour.dart';
import 'package:battle_it_out/persistence/item/melee_weapon.dart';
import 'package:battle_it_out/persistence/item/ranged_weapon.dart';
import 'package:battle_it_out/persistence/skill/skill.dart';
import 'package:battle_it_out/persistence/talent/talent.dart';
import 'package:battle_it_out/providers/ancestry_provider.dart';
import 'package:battle_it_out/providers/attribute_provider.dart';
import 'package:battle_it_out/providers/item/armour_provider.dart';
import 'package:battle_it_out/providers/item/item_provider.dart';
import 'package:battle_it_out/providers/item/melee_weapon_provider.dart';
import 'package:battle_it_out/providers/item/ranged_weapon_provider.dart';
import 'package:battle_it_out/providers/profession/profession_provider.dart';
import 'package:battle_it_out/providers/size_provider.dart';
import 'package:battle_it_out/providers/skill/skill_provider.dart';
import 'package:battle_it_out/providers/talent/talent_provider.dart';
import 'package:battle_it_out/utils/factory.dart';
import 'package:collection/collection.dart';
import 'package:get_it/get_it.dart';

class CharacterRepository extends Repository<Character> {
  @override
  get tableName => 'characters';

  @override
  Future<void> init() async {
    if (ready) return;
    await GetIt.instance.get<SizeRepository>().init();
    await GetIt.instance.get<AncestryRepository>().init();
    await GetIt.instance.get<ProfessionRepository>().init();
    await GetIt.instance.get<SkillRepository>().init();
    await GetIt.instance.get<TalentRepository>().init();
    await GetIt.instance.get<ArmourRepository>().init();
    await GetIt.instance.get<MeleeWeaponRepository>().init();
    await GetIt.instance.get<RangedWeaponRepository>().init();
    await super.init();
  }

  @override
  Future<Character> fromDatabase(dynamic map) async {
    List<Attribute> attributes = await getCharacterAttributes(map['ID']);
    List<Skill> skills = await getCharacterSkills(map['ID'], attributes);
    List<Talent> talents = await getCharacterTalents(map['ID'], attributes, skills);

    Character character = Character(
        id: map['ID'],
        name: map['NAME'],
        size: await GetIt.instance.get<SizeRepository>().get(map["SIZE"]),
        ancestry: await GetIt.instance.get<AncestryRepository>().get(map["ANCESTRY"]),
        profession: await GetIt.instance.get<ProfessionRepository>().get(map["PROFESSION"]),
        attributes: attributes,
        skills: skills,
        talents: talents,
        items: [for (var m in map["ITEMS"] ?? []) await GetIt.instance.get<ItemRepository>().fromDatabase(m)]);
    character.armour = await getCharacterArmour(map["ID"]);
    character.meleeWeapons = await getCharacterMeleeWeapons(map["ID"]);
    character.rangedWeapons = await getCharacterRangedWeapons(map["ID"]);
    return character;
  }

  @override
  Future<Character> fromMap(dynamic map) async {
    List<Attribute> attributes = await _createAttributes(map["ATTRIBUTES"]);
    List<Skill> skills = await _createSkills(map['SKILLS'] ?? [], attributes);
    List<Talent> talents = await _createTalents(map['TALENTS'] ?? [], attributes);
    List<MeleeWeapon> meleeWeapons = await _createMeleeWeapons(map['MELEE_WEAPONS'] ?? [], attributes, skills);

    Character character = Character(
      id: map['ID'],
      name: map['NAME'],
      size: map["SIZE"] != null ? await GetIt.instance.get<SizeRepository>().get(map["SIZE"]) : null,
      ancestry: map["SUBRACE"] != null ? await GetIt.instance.get<AncestryRepository>().create(map["SUBRACE"]) : null,
      profession:
          map["PROFESSION"] != null ? await GetIt.instance.get<ProfessionRepository>().create(map["PROFESSION"]) : null,
      attributes: attributes,
      skills: skills,
      talents: talents,
      meleeWeapons: meleeWeapons,
      items: [for (var m in map["ITEMS"] ?? []) await GetIt.instance.get<ItemRepository>().create(m)],
    );
    character.armour = [for (var m in map["ARMOUR"] ?? []) await GetIt.instance.get<ArmourRepository>().create(m)];
    character.meleeWeapons = meleeWeapons;
    character.rangedWeapons = [
      for (var m in map["RANGED_WEAPONS"] ?? []) await GetIt.instance.get<RangedWeaponRepository>().create(m)
    ];
    return character;
  }

  @override
  Future<Map<String, Object?>> toDatabase(Character object) async {
    return {
      "ID": object.id,
      "NAME": object.name,
      "ANCESTRY": object.ancestry?.id,
      "SIZE": object.size?.id,
      "PROFESSION": object.profession?.id,
    };
  }

  @override
  Future<Map<String, dynamic>> toMap(Character object, {optimised = true, database = false}) async {
    Map<String, dynamic> map = {
      "NAME": object.name,
      "SUBRACE": await GetIt.instance.get<AncestryRepository>().toDatabase(object.ancestry!),
      "PROFESSION": await GetIt.instance.get<ProfessionRepository>().toDatabase(object.profession!),
      "ATTRIBUTES": [
        for (var attribute in object.attributes) await GetIt.instance.get<AttributeRepository>().toMap(attribute)
      ],
      "SKILLS": [
        for (var skill in object.skills.where((s) => s.isImportant()))
          await GetIt.instance.get<SkillRepository>().toMap(skill)
      ],
      "TALENTS": [for (var talent in object.talents) await GetIt.instance.get<TalentRepository>().toMap(talent)],
      "MELEE_WEAPONS": [
        for (var weapon in object.meleeWeapons) await GetIt.instance.get<MeleeWeaponRepository>().toMap(weapon)
      ],
      "RANGED_WEAPONS": [
        for (var weapon in object.rangedWeapons) await GetIt.instance.get<RangedWeaponRepository>().toMap(weapon)
      ],
      "ARMOUR": [for (var armour in object.armour) await GetIt.instance.get<ArmourRepository>().toMap(armour)],
    };
    if (optimised) {
      map = await optimise(map);
    }
    return map;
  }

  @override
  Future<Character> update(Character object) async {
    await super.update(object);
    for (Attribute attribute in object.attributes) {
      await GetIt.instance.get<AttributeRepository>().update(attribute);
      await updateMap({
        "ATTRIBUTE_ID": attribute.id,
        "CHARACTER_ID": object.id,
        "BASE_VALUE": attribute.base,
        "ADVANCES": attribute.advances,
        "CAN_ADVANCE": attribute.canAdvance ? 1 : 0
      }, "character_attributes");
    }
    for (Skill skill in object.skills) {
      await GetIt.instance.get<SkillRepository>().update(skill);
      await updateMap({
        "SKILL_ID": skill.id,
        "CHARACTER_ID": object.id,
        "ADVANCES": skill.advances,
        "CAN_ADVANCE": skill.canAdvance ? 1 : 0,
        "EARNING": skill.earning ? 1 : 0
      }, "character_skills");
    }
    for (Talent talent in object.talents) {
      await GetIt.instance.get<TalentRepository>().update(talent);
      await updateMap({
        "TALENT_ID": talent.id,
        "CHARACTER_ID": object.id,
        "LEVEL": talent.currentLvl,
        "CAN_ADVANCE": talent.canAdvance ? 1 : 0,
      }, "character_talents");
    }
    for (Armour armour in object.armour) {
      await GetIt.instance.get<ArmourRepository>().update(armour);
      await updateMap({
        "ARMOUR_ID": armour.id,
        "CHARACTER_ID": object.id,
        "AMOUNT": armour.amount,
      }, "character_armour");
    }
    for (MeleeWeapon meleeWeapon in object.meleeWeapons) {
      await GetIt.instance.get<MeleeWeaponRepository>().update(meleeWeapon);
      await updateMap({
        "WEAPON_ID": meleeWeapon.id,
        "CHARACTER_ID": object.id,
        "AMOUNT": meleeWeapon.amount,
      }, "character_melee_weapons");
    }
    for (RangedWeapon rangedWeapon in object.rangedWeapons) {
      await GetIt.instance.get<RangedWeaponRepository>().update(rangedWeapon);
      await updateMap({
        "WEAPON_ID": rangedWeapon.id,
        "CHARACTER_ID": object.id,
        "AMOUNT": rangedWeapon.amount,
      }, "character_ranged_weapons");
    }
    return object;
  }

  //--------------

  Future<List<Attribute>> getCharacterAttributes(int characterId) async {
    final List<Map<String, dynamic>> map = await database.rawQuery(
        "SELECT * FROM CHARACTER_ATTRIBUTES CA JOIN ATTRIBUTES A on A.ID = CA.ATTRIBUTE_ID WHERE CA.CHARACTER_ID = ?",
        [characterId]);

    List<Attribute> attributes = [];
    for (Map<String, dynamic> entry in map) {
      Attribute attribute = await GetIt.instance.get<AttributeRepository>().fromDatabase(entry);
      attribute.base = entry["BASE_VALUE"];
      attribute.advances = entry["ADVANCES"];
      attribute.canAdvance = entry["CAN_ADVANCE"] == 1;
      attributes.add(attribute);
    }
    return attributes;
  }

  Future<List<Skill>> getCharacterSkills(int characterId, List<Attribute>? attributes) async {
    final List<Map<String, dynamic>> map = await database.rawQuery(
        "SELECT * FROM CHARACTER_SKILLS CS JOIN SKILLS S on S.ID = CS.SKILL_ID WHERE CS.CHARACTER_ID = ?",
        [characterId]);

    List<Skill> skills = await GetIt.instance.get<SkillRepository>().getSkills(advanced: false);
    for (Map<String, dynamic> entry in map) {
      Skill skill = await GetIt.instance.get<SkillRepository>().fromDatabase(entry);
      int index = skills.indexOf(skill);
      if (index != -1) {
        skills[index] = skill;
      } else {
        skills.add(skill);
      }
    }
    return skills;
  }

  Future<List<Talent>> getCharacterTalents(int characterId, List<Attribute>? attributes, List<Skill>? skills) async {
    final List<Map<String, dynamic>> map = await database.rawQuery(
        "SELECT * FROM CHARACTER_TALENTS CT JOIN TALENTS T on T.ID = CT.TALENT_ID WHERE CT.CHARACTER_ID = ?",
        [characterId]);

    List<Talent> talents = [];
    for (Map<String, dynamic> entry in map) {
      Talent talent = await GetIt.instance.get<TalentRepository>().fromDatabase(entry);
      talent.currentLvl = entry["LEVEL"];
      talent.canAdvance = entry["CAN_ADVANCE"] == 1;
      int index = talents.indexOf(talent);
      if (index != -1) {
        talents[index] = talent;
      } else {
        talents.add(talent);
      }
    }
    return talents;
  }

  Future<List<Armour>> getCharacterArmour(int characterId) async {
    List<Armour> armourList = [];
    for (Map<String, dynamic> entry in await database.rawQuery(
        "SELECT * FROM CHARACTER_ARMOUR CA JOIN ARMOUR A on A.ID = CA.ARMOUR_ID WHERE CA.CHARACTER_ID = ?",
        [characterId])) {
      Armour armour = await GetIt.instance.get<ArmourRepository>().fromDatabase(entry);
      armour.amount = entry["AMOUNT"];
      armourList.add(armour);
    }
    return armourList;
  }

  Future<List<MeleeWeapon>> getCharacterMeleeWeapons(int characterId) async {
    List<MeleeWeapon> meleeWeapons = [];
    for (Map<String, dynamic> entry in await database.rawQuery(
        "SELECT * FROM CHARACTER_MELEE_WEAPONS CMW JOIN WEAPONS_MELEE WM on WM.ID = CMW.WEAPON_ID WHERE CMW.CHARACTER_ID = ?",
        [characterId])) {
      MeleeWeapon meleeWeapon = await GetIt.instance.get<MeleeWeaponRepository>().fromDatabase(entry);
      meleeWeapon.amount = entry["AMOUNT"];
      meleeWeapons.add(meleeWeapon);
    }
    return meleeWeapons;
  }

  Future<List<RangedWeapon>> getCharacterRangedWeapons(int characterId) async {
    List<RangedWeapon> rangedWeapons = [];
    for (Map<String, dynamic> entry in await database.rawQuery(
        "SELECT * FROM CHARACTER_RANGED_WEAPONS CRW JOIN WEAPONS_RANGED WR on WR.ID = CRW.WEAPON_ID WHERE CRW.CHARACTER_ID = ?",
        [characterId])) {
      RangedWeapon rangedWeapon = await GetIt.instance.get<RangedWeaponRepository>().fromDatabase(entry);
      rangedWeapon.amount = entry["AMOUNT"];
      rangedWeapons.add(rangedWeapon);
    }
    return rangedWeapons;
  }

  //--------------

  Future<List<Attribute>> _createAttributes(json) async {
    List<Attribute> attributes = await GetIt.instance.get<AttributeRepository>().getAll();
    for (var map in json ?? []) {
      Attribute attribute = await GetIt.instance.get<AttributeRepository>().create(map);
      int index = attributes.indexOf(attribute);
      if (index != -1) {
        attributes[index] = attribute;
      } else {
        attributes.add(attribute);
      }
    }
    return attributes;
  }

  Future<List<Skill>> _createSkills(json, List<Attribute> attributes) async {
    List<Skill> skills = await GetIt.instance.get<SkillRepository>().getSkills(advanced: false);
    for (var map in json ?? []) {
      Skill skill = await GetIt.instance.get<SkillRepository>().create(map);
      linkSkill(attributes, skill);
      int index = skills.indexOf(skill);
      if (index != -1) {
        skills[index] = skill;
      } else {
        skills.add(skill);
      }
    }
    return skills;
  }

  Future<List<Talent>> _createTalents(json, List<Attribute> attributes) async {
    List<Talent> talents = [];
    for (var map in json ?? []) {
      Talent talent = await GetIt.instance.get<TalentRepository>().create(map);
      linkTalent(attributes, talent);
      talents.add(talent);
    }
    return talents;
  }

  Future<List<MeleeWeapon>> _createMeleeWeapons(json, List<Attribute> attributes, List<Skill> skills) async {
    List<MeleeWeapon> meleeWeapons = [];
    for (var map in json ?? []) {
      MeleeWeapon weapon = await GetIt.instance.get<MeleeWeaponRepository>().create(map);
      linkMeleeWeapon(attributes, skills, weapon);
      meleeWeapons.add(weapon);
    }
    return meleeWeapons;
  }

  void linkSkill(List<Attribute> attributes, Skill skill) {
    Attribute? linkAttribute = attributes.firstWhereOrNull((a) => a.id == skill.baseSkill.attribute.id);
    if (linkAttribute != null) skill.baseSkill.attribute = linkAttribute;
  }

  void linkTalent(List<Attribute> attributes, Talent talent) {
    Attribute? linkAttribute = attributes.firstWhereOrNull((a) => a.id == talent.baseTalent.attribute?.id);
    if (linkAttribute != null) talent.baseTalent.attribute = linkAttribute;
  }

  void linkMeleeWeapon(List<Attribute> attributes, List<Skill> skills, MeleeWeapon weapon) {
    Attribute? linkAttribute = attributes.firstWhereOrNull((a) => a.id == weapon.damageAttribute?.id);
    Skill? linkedSkill = skills.firstWhereOrNull((s) => s.id == weapon.skill?.id);
    if (linkAttribute != null) weapon.damageAttribute = linkAttribute;
    if (linkedSkill != null) weapon.skill = linkedSkill;
  }
}
