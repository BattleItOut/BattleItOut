import 'package:battle_it_out/persistence/dao/armour_dao.dart';
import 'package:battle_it_out/persistence/dao/attribute_dao.dart';
import 'package:battle_it_out/persistence/dao/melee_weapon_dao.dart';
import 'package:battle_it_out/persistence/dao/profession_dao.dart';
import 'package:battle_it_out/persistence/dao/race_dao.dart';
import 'package:battle_it_out/persistence/dao/ranged_weapon_dao.dart';
import 'package:battle_it_out/persistence/dao/skill_dao.dart';
import 'package:battle_it_out/persistence/dao/talent_dao.dart';
import 'package:battle_it_out/persistence/entities/melee_weapon.dart';
import 'package:battle_it_out/persistence/entities/ranged_weapon.dart';
import 'package:battle_it_out/persistence/entities/skill.dart';
import 'package:battle_it_out/persistence/entities/talent.dart';
import 'package:battle_it_out/persistence/entities/attribute.dart';
import 'package:battle_it_out/persistence/entities/profession.dart';
import 'package:battle_it_out/persistence/entities/race.dart';
import 'package:battle_it_out/persistence/entities/armour.dart';
import 'package:flutter/foundation.dart';

class Character {
  String name;
  Race race;
  Profession profession;
  Map<int, Attribute> attributes;
  Map<int, Skill> skills;
  Map<int, Talent> talents;
  List<Armour> armour;
  List<MeleeWeapon> meleeWeapons;
  List<RangedWeapon> rangedWeapons;
  int? initiative;
  // List<Trait> traits;

  Character(
      {required this.name,
      required this.race,
      required this.profession,
      required this.attributes,
      this.skills = const {},
      this.talents = const {},
      this.meleeWeapons = const [],
      this.rangedWeapons = const [],
      this.armour = const []});

  static Character from(Character character) {
    var newInstance = Character(
        name: character.name, race: character.race, profession: character.profession, attributes: character.attributes);
    newInstance.skills = character.skills;
    newInstance.talents = character.talents;
    newInstance.initiative = character.initiative;
    return newInstance;
  }

  static Future<Character> create(dynamic json) async {
    String name = json['NAME'];
    Race race = await RaceFactory().create(json["RACE"]);
    Profession profession = await ProfessionFactory().create(json["PROFESSION"]);
    Map<int, Attribute> attributes = await _createAttributes(json["ATTRIBUTES"]);
    Map<int, Skill> skills = await _createSkills(json['SKILLS'] ?? [], attributes);
    Map<int, Talent> talents = await _createTalents(json['TALENTS'] ?? [], attributes);
    List<MeleeWeapon> meleeWeapons = [for (var map in json["MELEE_WEAPONS"] ?? []) await MeleeWeaponFactory(attributes, skills).create(map)];
    List<RangedWeapon> rangedWeapons = [for (var map in json["RANGED_WEAPONS"] ?? []) await RangedWeaponFactory(attributes, skills).create(map)];
    List<Armour> armour = [for (var map in json["ARMOUR"] ?? []) await ArmourFactory().create(map)];

    Character character = Character(
        name: name,
        race: race,
        profession: profession,
        attributes: attributes,
        skills: skills,
        talents: talents,
        meleeWeapons: meleeWeapons,
        rangedWeapons: rangedWeapons,
        armour: armour);

    return character;
  }

  static Future<Map<int, Attribute>> _createAttributes(json) async {
    Map<int, Attribute> attributes = {
      for (Attribute attribute in await AttributeFactory().getAll())
        attribute.id: attribute
    };
    for (var map in json ?? []) {
      Attribute attribute = await AttributeFactory().create(map);
      attributes[attribute.id] = attribute;
    }
    return attributes;
  }

  static Future<Map<int, Skill>> _createSkills(json, Map<int, Attribute> attributes) async {
    Map<int, Skill> skills = {
      for (Skill skill in await SkillFactory(attributes).getSkills(advanced: false))
        skill.id: skill
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

  // List getters
  List<Attribute> getAttributes() {
    return List.of(attributes.values);
  }

  Map<BaseSkill, List<Skill>> getBasicSkillsGrouped() {
    Map<BaseSkill, List<Skill>> output = {};
    for (var skill in skills.values.where((skill) => !skill.isAdvanced())) {
      var category = skill.baseSkill!;
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
    for (var skill in skills.values.where((skill) => skill.isAdvanced())) {
      var category = skill.baseSkill!;
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
    for (var talent in talents.values) {
      var category = talent.baseTalent!;
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

  Future<Map<String, dynamic>> toMap() async {
    Map<String, dynamic> map = {
      "NAME": name,
      "RACE": await RaceFactory().toMap(race),
      "PROFESSION": await ProfessionFactory().toMap(profession),
      "ATTRIBUTES": [for (Attribute attribute in attributes.values.where((element) => element.base != 0)) await AttributeFactory().toMap(attribute)],
      "SKILLS": [for (Skill skill in skills.values.where((element) => element.advances != 0 || element.advancable || element.earning)) await SkillFactory().toMap(skill)],
      "TALENTS": [for (Talent talent in talents.values) await TalentFactory().toMap(talent)],
      "MELEE_WEAPONS": [for (MeleeWeapon weapon in meleeWeapons) await MeleeWeaponFactory().toMap(weapon)],
      "RANGED_WEAPONS": [for (RangedWeapon weapon in rangedWeapons) await RangedWeaponFactory().toMap(weapon)],
      "ARMOUR": [for (Armour armour in this.armour) await ArmourFactory().toMap(armour)],
    };
    map.removeWhere((key, value) => value is List && value.isEmpty);
    return map;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Character &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          race == other.race &&
          profession == other.profession &&
          mapEquals(attributes, other.attributes) &&
          mapEquals(skills, other.skills) &&
          mapEquals(talents, other.talents) &&
          listEquals(armour, other.armour) &&
          listEquals(meleeWeapons, other.meleeWeapons) &&
          listEquals(rangedWeapons, other.rangedWeapons) &&
          initiative == other.initiative;

  @override
  int get hashCode =>
      name.hashCode ^
      race.hashCode ^
      profession.hashCode ^
      attributes.hashCode ^
      skills.hashCode ^
      talents.hashCode ^
      armour.hashCode ^
      meleeWeapons.hashCode ^
      rangedWeapons.hashCode ^
      initiative.hashCode;

  @override
  String toString() {
    return "Character (name=$name, race=$race, profession=$profession)";
  }
}
