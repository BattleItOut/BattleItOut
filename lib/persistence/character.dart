import 'package:battle_it_out/persistence/attribute.dart';
import 'package:battle_it_out/persistence/item/armour.dart';
import 'package:battle_it_out/persistence/item/item.dart';
import 'package:battle_it_out/persistence/item/melee_weapon.dart';
import 'package:battle_it_out/persistence/item/ranged_weapon.dart';
import 'package:battle_it_out/persistence/profession/profession.dart';
import 'package:battle_it_out/persistence/size.dart';
import 'package:battle_it_out/persistence/skill/skill.dart';
import 'package:battle_it_out/persistence/skill/skill_base.dart';
import 'package:battle_it_out/persistence/subrace.dart';
import 'package:battle_it_out/persistence/talent/talent.dart';
import 'package:battle_it_out/persistence/talent/talent_base.dart';
import 'package:battle_it_out/persistence/trait.dart';
import 'package:battle_it_out/utils/db_object.dart';
import 'package:battle_it_out/utils/factory.dart';
import 'package:flutter/foundation.dart' hide Factory;

class Character extends DBObject {
  String name;
  String? description;
  Size? size;
  Subrace? subrace;
  Profession? profession;
  List<Attribute> attributes = [];
  List<Skill> skills = [];
  List<Talent> talents = [];
  List<Trait> traits = [];
  List<Item> items = [];
  List<Armour> armour = [];
  List<MeleeWeapon> meleeWeapons = [];
  List<RangedWeapon> rangedWeapons = [];

  // Temporary
  int? initiative;

  Character(
      {super.id,
      required this.name,
      this.size,
      this.subrace,
      this.profession,
      this.description,
      this.initiative,
      List<Attribute> attributes = const [],
      List<Skill> skills = const [],
      List<Talent> talents = const [],
      List<Trait> traits = const [],
      List<Item> items = const []}) {
    this.items.addAll(items);
    this.attributes.addAll(attributes);
    this.skills.addAll(skills);
    this.talents.addAll(talents);
    this.traits.addAll(traits);
  }

  Size? getSize() {
    return subrace?.race.size ?? size;
  }

  // List getters
  Map<BaseSkill, List<Skill>> getBasicSkillsGrouped() {
    Map<BaseSkill, List<Skill>> output = {};
    for (var skill in skills.where((skill) => !skill.isAdvanced())) {
      var category = skill.baseSkill;
      if (output.containsKey(category)) {
        output[category]!.add(skill);
      } else {
        output[category] = [skill];
      }
    }
    return output;
  }

  Map<BaseSkill, List<Skill>> getAdvancedSkillsGrouped() {
    Map<BaseSkill, List<Skill>> output = {};
    for (var skill in skills.where((skill) => skill.isAdvanced())) {
      var category = skill.baseSkill;
      if (output.containsKey(category)) {
        output[category]!.add(skill);
      } else {
        output[category] = [skill];
      }
    }
    return output;
  }

  Map<BaseTalent, List<Talent>> getTalentsGrouped() {
    Map<BaseTalent, List<Talent>> output = {};
    for (var talent in talents) {
      var category = talent.baseTalent;
      if (output.containsKey(category)) {
        output[category]!.add(talent);
      } else {
        output[category] = [talent];
      }
    }
    return output;
  }

  Map<Skill, List<MeleeWeapon>> getMeleeWeaponsGrouped() {
    Map<Skill, List<MeleeWeapon>> output = {};
    for (MeleeWeapon meleeWeapon in meleeWeapons) {
      var category = meleeWeapon.skill!;
      if (output.containsKey(category)) {
        output[category]!.add(meleeWeapon);
      } else {
        output[category] = [meleeWeapon];
      }
    }
    return output;
  }

  Map<Skill, List<RangedWeapon>> getRangedWeaponsGrouped() {
    Map<Skill, List<RangedWeapon>> output = {};
    for (RangedWeapon weapon in rangedWeapons) {
      var category = weapon.skill!;
      if (output.containsKey(category)) {
        output[category]!.add(weapon);
      } else {
        output[category] = [weapon];
      }
    }
    return output;
  }

  // Items
  Map<String, Map<Item, int>> getCommonItemsGrouped() {
    Map<String, Map<Item, int>> output = {};
    for (Item item in items) {
      String category = item.category ?? "NONE";
      if (output.containsKey(category)) {
        output[category]![item] = item.amount;
      } else {
        output[category] = {item: item.amount};
      }
    }
    return output;
  }

  static Character from(Character character) {
    return Character(
        name: character.name,
        subrace: character.subrace,
        profession: character.profession,
        attributes: character.attributes.toList(),
        skills: character.skills,
        talents: character.talents,
        traits: character.traits,
        items: character.items,
        initiative: character.initiative);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Character &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          subrace == other.subrace &&
          profession == other.profession &&
          listEquals(attributes, other.attributes) &&
          listEquals(skills, other.skills) &&
          listEquals(talents, other.talents) &&
          listEquals(items, other.items);

  @override
  int get hashCode =>
      name.hashCode ^
      subrace.hashCode ^
      profession.hashCode ^
      attributes.hashCode ^
      skills.hashCode ^
      talents.hashCode ^
      items.hashCode;

  @override
  String toString() {
    return "Character (name=$name, subrace=$subrace, profession=$profession)";
  }
}

class CharacterFactory extends Factory<Character> {
  @override
  get tableName => 'characters';

  @override
  Future<Character> fromDatabase(dynamic map) async {
    List<Attribute> attributes = await getCharacterAttributes(map['ID']);
    List<Skill> skills = await getCharacterSkills(map['ID'], attributes);
    List<Talent> talents = await getCharacterTalents(map['ID'], attributes, skills);

    Character character = Character(
        id: map['ID'],
        name: map['NAME'],
        size: await SizeFactory().getNullable(map["SIZE"]),
        subrace: await SubraceFactory().getNullable(map["ANCESTRY"]),
        profession: await ProfessionFactory().getNullable(map["PROFESSION"]),
        attributes: attributes,
        skills: skills,
        talents: talents,
        items: [for (var m in map["ITEMS"] ?? []) await CommonItemFactory().fromDatabase(m)]);
    character.armour = await getCharacterArmour(map["ID"]);
    character.meleeWeapons = await getCharacterMeleeWeapons(map["ID"]);
    character.rangedWeapons = await getCharacterRangedWeapons(map["ID"]);
    return character;
  }

  @override
  Future<Character> fromMap(dynamic map) async {
    List<Attribute> attributes = await _createAttributes(map["ATTRIBUTES"]);
    List<Skill> skills = await _createSkills(map['SKILLS'] ?? [], attributes);
    List<Talent> talents = [for (var m in map['TALENTS'] ?? []) await TalentFactory(attributes, skills).create(m)];

    Character character = Character(
      id: map['ID'],
      name: map['NAME'],
      size: map["SIZE"] != null ? await SizeFactory().get(map["SIZE"]) : null,
      subrace: map["SUBRACE"] != null ? await SubraceFactory().create(map["SUBRACE"]) : null,
      profession: map["PROFESSION"] != null ? await ProfessionFactory().create(map["PROFESSION"]) : null,
      attributes: attributes,
      skills: skills,
      talents: talents,
      items: [for (var m in map["ITEMS"] ?? []) await CommonItemFactory().create(m)],
    );
    character.armour = [for (var m in map["ARMOUR"] ?? []) await ArmourFactory().create(m)];
    character.meleeWeapons = [
      for (var m in map["MELEE_WEAPONS"] ?? []) await MeleeWeaponFactory(attributes, skills).create(m)
    ];
    character.rangedWeapons = [
      for (var m in map["RANGED_WEAPONS"] ?? []) await RangedWeaponFactory(attributes, skills).create(m)
    ];
    return character;
  }

  @override
  Future<Map<String, Object?>> toDatabase(Character object) async {
    return {
      "ID": object.id,
      "NAME": object.name,
      "ANCESTRY": object.subrace?.id,
      "SIZE": object.size?.id,
      "PROFESSION": object.profession?.id,
    };
  }

  @override
  Future<Map<String, dynamic>> toMap(Character object, {optimised = true, database = false}) async {
    Map<String, dynamic> map = {
      "NAME": object.name,
      "SUBRACE": await SubraceFactory().toDatabase(object.subrace!),
      "PROFESSION": await ProfessionFactory().toDatabase(object.profession!),
      "ATTRIBUTES": [for (var attribute in object.attributes) await AttributeFactory().toMap(attribute)],
      "SKILLS": [for (var skill in object.skills.where((s) => s.isImportant())) await SkillFactory().toMap(skill)],
      "TALENTS": [for (var talent in object.talents) await TalentFactory().toMap(talent)],
      "MELEE_WEAPONS": [for (var weapon in object.meleeWeapons) await MeleeWeaponFactory().toMap(weapon)],
      "RANGED_WEAPONS": [for (var weapon in object.rangedWeapons) await RangedWeaponFactory().toMap(weapon)],
      "ARMOUR": [for (var armour in object.armour) await ArmourFactory().toMap(armour)],
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
      await AttributeFactory().update(attribute);
      await insertMap({
        "ATTRIBUTE_ID": attribute.id,
        "CHARACTER_ID": object.id,
        "BASE_VALUE": attribute.base,
        "ADVANCES": attribute.advances,
        "CAN_ADVANCE": attribute.canAdvance ? 1 : 0
      }, "character_attributes");
    }
    for (Skill skill in object.skills) {
      await SkillFactory().update(skill);
      await insertMap({
        "SKILL_ID": skill.id,
        "CHARACTER_ID": object.id,
        "ADVANCES": skill.advances,
        "CAN_ADVANCE": skill.canAdvance ? 1 : 0,
        "EARNING": skill.earning ? 1 : 0
      }, "character_skills");
    }
    for (Talent talent in object.talents) {
      await TalentFactory().update(talent);
      await insertMap({
        "TALENT_ID": talent.id,
        "CHARACTER_ID": object.id,
        "LEVEL": talent.currentLvl,
        "CAN_ADVANCE": talent.canAdvance ? 1 : 0,
      }, "character_talents");
    }
    for (Armour armour in object.armour) {
      await ArmourFactory().update(armour);
      await insertMap({
        "ARMOUR_ID": armour.id,
        "CHARACTER_ID": object.id,
        "AMOUNT": armour.amount,
      }, "character_armour");
    }
    for (MeleeWeapon meleeWeapon in object.meleeWeapons) {
      await MeleeWeaponFactory().update(meleeWeapon);
      await insertMap({
        "WEAPON_ID": meleeWeapon.id,
        "CHARACTER_ID": object.id,
        "AMOUNT": meleeWeapon.amount,
      }, "character_melee_weapons");
    }
    for (RangedWeapon rangedWeapon in object.rangedWeapons) {
      await RangedWeaponFactory().update(rangedWeapon);
      await insertMap({
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
      Attribute attribute = await AttributeFactory().fromDatabase(entry);
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

    List<Skill> skills = await SkillFactory(attributes).getSkills(advanced: false);
    for (Map<String, dynamic> entry in map) {
      Skill skill = await SkillFactory(attributes).fromDatabase(entry);
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
      Talent talent = await TalentFactory(attributes, skills).fromDatabase(entry);
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
      Armour armour = await ArmourFactory().fromDatabase(entry);
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
      MeleeWeapon meleeWeapon = await MeleeWeaponFactory().fromDatabase(entry);
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
      RangedWeapon rangedWeapon = await RangedWeaponFactory().fromDatabase(entry);
      rangedWeapon.amount = entry["AMOUNT"];
      rangedWeapons.add(rangedWeapon);
    }
    return rangedWeapons;
  }

  //--------------

  Future<List<Attribute>> _createAttributes(json) async {
    List<Attribute> attributes = await AttributeFactory().getAll();
    for (var map in json ?? []) {
      Attribute attribute = await AttributeFactory().create(map);
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
    List<Skill> skills = await SkillFactory(attributes).getSkills(advanced: false);
    for (var map in json ?? []) {
      Skill skill = await SkillFactory(attributes).create(map);
      int index = skills.indexOf(skill);
      if (index != -1) {
        skills[index] = skill;
      } else {
        skills.add(skill);
      }
    }
    return skills;
  }
}
