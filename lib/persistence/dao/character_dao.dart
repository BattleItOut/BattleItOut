import 'package:battle_it_out/persistence/dao/armour_dao.dart';
import 'package:battle_it_out/persistence/dao/attribute_dao.dart';
import 'package:battle_it_out/persistence/dao/melee_weapon_dao.dart';
import 'package:battle_it_out/persistence/dao/profession_dao.dart';
import 'package:battle_it_out/persistence/dao/race_dao.dart';
import 'package:battle_it_out/persistence/dao/ranged_weapon_dao.dart';
import 'package:battle_it_out/persistence/dao/serializer.dart';
import 'package:battle_it_out/persistence/dao/skill_dao.dart';
import 'package:battle_it_out/persistence/dao/talent_dao.dart';
import 'package:battle_it_out/persistence/entities/armour.dart';
import 'package:battle_it_out/persistence/entities/attribute.dart';
import 'package:battle_it_out/persistence/entities/character.dart';
import 'package:battle_it_out/persistence/entities/item.dart';
import 'package:battle_it_out/persistence/entities/melee_weapon.dart';
import 'package:battle_it_out/persistence/entities/profession.dart';
import 'package:battle_it_out/persistence/entities/race.dart';
import 'package:battle_it_out/persistence/entities/ranged_weapon.dart';
import 'package:battle_it_out/persistence/entities/skill.dart';
import 'package:battle_it_out/persistence/entities/talent.dart';

class CharacterFactory extends Factory<Character> {
  @override
  get tableName => 'skills';

  @override
  Future<Character> fromMap(dynamic json) async {
    String name = json['NAME'];
    Race race = await RaceFactory().create(json["RACE"]);
    Profession profession = await ProfessionFactory().create(json["PROFESSION"]);
    Map<int, Attribute> attributes = await _createAttributes(json["ATTRIBUTES"]);
    Map<int, Skill> skills = await _createSkills(json['SKILLS'] ?? [], attributes);
    Map<int, Talent> talents = await _createTalents(json['TALENTS'] ?? [], attributes);

    List<Item> items = [];
    for (Map<String, dynamic> map in json["MELEE_WEAPONS"] ?? []) {
      items.add(await MeleeWeaponFactory(attributes, skills).create(map));
    }
    for (Map<String, dynamic> map in json["RANGED_WEAPONS"] ?? []) {
      items.add(await RangedWeaponFactory(attributes, skills).create(map));
    }
    for (Map<String, dynamic> map in json["ARMOUR"] ?? []) {
      items.add(await ArmourFactory().create(map));
    }
    // for (var map in json["ITEMS"] ?? []) {
    //   items.add(await ItemFactory().create(map));
    // }

    Character character = Character(
        name: name,
        race: race,
        profession: profession,
        attributes: attributes,
        skills: skills,
        talents: talents,
        items: items);

    return character;
  }

  @override
  Future<Map<String, dynamic>> toMap(Character object, [optimised = true]) async {
    List meleeWeapons = [];
    for (MeleeWeapon weapon in object.getMeleeWeapons()) {
      meleeWeapons.add(await MeleeWeaponFactory().toMap(weapon));
    }

    List rangedWeapons = [];
    for (RangedWeapon weapon in object.getRangedWeapons()) {
      rangedWeapons.add(await RangedWeaponFactory().toMap(weapon));
    }

    List armourList = [];
    for (Armour armour in object.getArmour()) {
      armourList.add(await ArmourFactory().toMap(armour));
    }

    Map<String, dynamic> map = {
      "NAME": object.name,
      "ATTRIBUTES": [
        for (Attribute attribute in object.attributes.values.where((element) => element.base != 0))
          await AttributeFactory().toMap(attribute)
      ],
      "SKILLS": [
        for (Skill skill in object.skills.values.where((element) => element.advances != 0 || element.canAdvance || element.earning))
          await SkillFactory().toMap(skill)
      ],
      "TALENTS": [for (Talent talent in object.talents.values) await TalentFactory().toMap(talent)],
      "MELEE_WEAPONS": meleeWeapons,
      "RANGED_WEAPONS": rangedWeapons,
      "ARMOUR": armourList,
    };
    if (object.race != null) {
      map["RACE"] = await RaceFactory().toMap(object.race!);
    }
    if (object.profession != null) {
      map["PROFESSION"] = await ProfessionFactory().toMap(object.profession!);
    }

    map.removeWhere((key, value) => value is List && value.isEmpty);
    return map;
  }

  static Future<Map<int, Attribute>> _createAttributes(json) async {
    Map<int, Attribute> attributes = {
      for (Attribute attribute in await AttributeFactory().getAll()) attribute.id: attribute
    };
    for (var map in json ?? []) {
      Attribute attribute = await AttributeFactory().create(map);
      attributes[attribute.id] = attribute;
    }
    return attributes;
  }

  static Future<Map<int, Skill>> _createSkills(json, Map<int, Attribute> attributes) async {
    Map<int, Skill> skills = {
      for (Skill skill in await SkillFactory(attributes).getSkills(advanced: false)) skill.id: skill
    };
    for (var map in json ?? []) {
      Skill skill = await SkillFactory(attributes).create(map);
      skills[skill.id] = skill;
    }
    return skills;
  }

  static Future<Map<int, Talent>> _createTalents(json, Map<int, Attribute> attributes) async {
    Map<int, Talent> talents = {};
    for (var map in json ?? []) {
      Talent talent = await TalentFactory(attributes).create(map);
      talents[talent.id] = talent;
    }
    return talents;
  }
}
