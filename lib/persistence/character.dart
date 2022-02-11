import 'dart:convert';
import 'package:battle_it_out/persistence/DTO/melee_weapon.dart';
import 'package:battle_it_out/persistence/DTO/ranged_weapon.dart';
import 'package:battle_it_out/persistence/DTO/skill.dart';
import 'package:battle_it_out/persistence/DTO/talent.dart';
import 'package:battle_it_out/persistence/DTO/attribute.dart';
import 'package:battle_it_out/persistence/DTO/profession.dart';
import 'package:battle_it_out/persistence/DTO/race.dart';
import 'package:battle_it_out/persistence/DTO/armour.dart';
import 'package:battle_it_out/persistence/wfrp_database.dart';
import 'package:flutter/services.dart';

class Character {
  String name;
  Race race;
  Subrace subrace;
  Profession profession;
  Map<int, Attribute> attributes;
  Map<int, Skill> skills = {};
  Map<int, Talent> talents = {};
  List<Armour> armour = [];
  List<MeleeWeapon> meleeWeapons = [];
  List<RangedWeapon> rangedWeapons = [];
  int? initiative;
  // List<Trait> traits;

  Character(
      {required this.name,
      required this.race,
      required this.subrace,
      required this.profession,
      required this.attributes,
      this.armour = const [],
      this.meleeWeapons = const [],
      this.rangedWeapons = const []});

  static Character from(Character character) {
    var newInstance = Character(
        name: character.name,
        race: character.race,
        subrace: character.subrace,
        profession: character.profession,
        attributes: character.attributes
    );
    newInstance.skills = character.skills;
    newInstance.talents = character.talents;
    newInstance.initiative = character.initiative;
    return newInstance;
  }

  static Future<Character> create(String jsonPath, WFRPDatabase database) async {
    var json = await _loadJson(jsonPath);
    Character character = Character(
        name: json['name'],
        race: await database.getRace(json["race_id"]),
        subrace: await database.getSubrace(json["subrace_id"]),
        profession: await database.getProfession(json["profession_id"]),
        attributes: await _getAttributes(json, database),
        armour: await _getArmour(json["armour"], database));
    character.skills = await _getSkills(json['skills'], character.attributes, database);
    character.talents = await _getTalents(json['talents'], character.attributes, database);
    character.meleeWeapons =
        await _getMeleeWeapons(json["melee_weapons"], character.skills, character.attributes, database);
    character.rangedWeapons =
        await _getRangedWeapons(json["ranged_weapons"], character.skills, character.attributes, database);
    return character;
  }

  static Future<List<RangedWeapon>> _getRangedWeapons(
      json, Map<int, Skill> skills, Map<int, Attribute> attributes, WFRPDatabase database) async {
    List<RangedWeapon> weaponList = [];
    for (var map in json ?? []) {
      RangedWeapon weapon = await database.getRangedWeapon(map["weapon_id"], skills, attributes);
      weapon.ammunition = map["ammunition"] ?? 0;
      for (var qualityMap in map["qualities"] ?? []) {
        weapon.addQuality(await database.getQuality(qualityMap["quality_id"]));
      }
      weaponList.add(weapon);
    }
    return weaponList;
  }

  static Future<List<MeleeWeapon>> _getMeleeWeapons(
      json, Map<int, Skill> skills, Map<int, Attribute> attributes, WFRPDatabase database) async {
    List<MeleeWeapon> weaponList = [];
    for (var map in json ?? []) {
      MeleeWeapon weapon = await database.getMeleeWeapon(map["weapon_id"], skills, attributes);
      map["name"] != null ? weapon.name = map["name"] : null;
      map["length"] != null ? weapon.length = map["length"] : null;
      for (var qualityMap in map["qualities"] ?? []) {
        weapon.addQuality(await database.getQuality(qualityMap["quality_id"]));
      }
      weaponList.add(weapon);
    }
    return weaponList;
  }

  static Future<List<Armour>> _getArmour(json, WFRPDatabase database) async {
    List<Armour> armourList = [];
    for (var map in json ?? []) {
      Armour armour = await database.getArmour(map["armour_id"]);
      map["head_AP"] != null ? armour.headAP = map["head_AP"] : null;
      map["body_AP"] != null ? armour.bodyAP = map["body_AP"] : null;
      map["left_arm_AP"] != null ? armour.leftArmAP = map["left_arm_AP"] : null;
      map["right_arm_AP"] != null ? armour.rightArmAP = map["right_arm_AP"] : null;
      map["left_leg_AP"] != null ? armour.leftLegAP = map["left_leg_AP"] : null;
      map["right_leg_AP"] != null ? armour.rightLegAP = map["right_leg_AP"] : null;
      armourList.add(armour);
    }
    return armourList;
  }

  static Future<Map<int, Skill>> _getSkills(json, Map<int, Attribute> attributes, WFRPDatabase database) async {
    Map<int, Skill> skillsMap = {};
    for (var map in json ?? []) {
      Skill skill = await database.getSkill(map["skill_id"], attributes);
      map["advances"] != null ? skill.advances = map["advances"] : null;
      map["advancable"] != null ? skill.advancable = map["advancable"] : null;
      map["earning"] != null ? skill.earning = map["earning"] : null;
      skillsMap[skill.id] = skill;
    }
    return skillsMap;
  }

  static Future<Map<int, Talent>> _getTalents(json, Map<int, Attribute> attributes, WFRPDatabase database) async {
    Map<int, Talent> talentsMap = {};
    for (var map in json ?? []) {
      Talent talent = await database.getTalent(map["talent_id"], attributes);
      map["lvl"] != null ? talent.currentLvl = map["lvl"] : null;
      map["advancable"] != null ? talent.advancable = map["advancable"] : null;
      talentsMap[talent.id] = talent;
    }
    return talentsMap;
  }

  static Future<Map<int, Attribute>> _getAttributes(json, WFRPDatabase database) async {
    Map<int, Attribute> attributes = await database.getAttributesByRace(json["race_id"]);

    for (var attributeMap in json['attributes']) {
      attributes[attributeMap["id"]]!.base = attributeMap["base"];
      attributes[attributeMap["id"]]!.advances = attributeMap["advances"] ?? 0;
    }

    return attributes;
  }

  static _loadJson(String jsonPath) async {
    String data = await rootBundle.loadString(jsonPath);
    return jsonDecode(data);
  }

  // List getters

  List<Attribute> getAttributes() {
    return List.of(attributes.values);
  }

  List<Skill> getSkills() {
    return List.of(skills.values);
  }

  List<Talent> getTalents() {
    return List.of(talents.values);
  }

  @override
  String toString() {
    return "Character (name=$name, race=$race), profession=$profession";
  }
}
