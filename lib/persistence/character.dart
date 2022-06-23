import 'package:battle_it_out/persistence/dao/armour_dao.dart';
import 'package:battle_it_out/persistence/dao/attribute_dao.dart';
import 'package:battle_it_out/persistence/dao/item_quality_dao.dart';
import 'package:battle_it_out/persistence/dao/length_dao.dart';
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

class Character {
  String name;
  Race race;
  Profession profession;
  Map<int, Attribute> attributes;
  Map<int, Skill> skills;
  Map<int, Talent> talents = {};
  List<Armour> armour = [];
  List<MeleeWeapon> meleeWeapons = [];
  List<RangedWeapon> rangedWeapons = [];
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
    Map<int, Skill> skills = await _createSkills(json['SKILLS'], attributes);
    Map<int, Talent> talents = await _createTalents(json['TALENTS'], attributes);
    List<MeleeWeapon> meleeWeapons = await _createMeleeWeapons(json["melee_weapons"], attributes, skills);
    List<RangedWeapon> rangedWeapons = await _createRangedWeapons(json["ranged_weapons"], attributes, skills);
    List<Armour> armour = await _createArmour(json["armour"]);

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

  static Future<List<RangedWeapon>> _createRangedWeapons(
      json, Map<int, Attribute> attributes, Map<int, Skill> skills) async {
    List<RangedWeapon> weaponList = [];
    for (var map in json ?? []) {
      RangedWeapon weapon = await RangedWeaponFactory(attributes, skills).create(map);
      for (var qualityMap in map["qualities"] ?? []) {
        weapon.addQuality(await ItemQualityFactory().get(qualityMap["quality_id"]));
      }
      weaponList.add(weapon);
    }
    return weaponList;
  }

  static Future<List<MeleeWeapon>> _createMeleeWeapons(
      json, Map<int, Attribute> attributes, Map<int, Skill> skills) async {
    List<MeleeWeapon> weaponList = [];
    for (var map in json ?? []) {
      MeleeWeapon weapon = await MeleeWeaponFactory(attributes, skills).get(map["ID"]);
      map["NAME"] != null ? weapon.name = map["NAME"] : null;
      map["LENGTH"] != null ? weapon.length = await WeaponLengthFactory().get(map["LENGTH"]) : null;
      for (var qualityMap in map["qualities"] ?? []) {
        weapon.addQuality(await ItemQualityFactory().get(qualityMap["QUALITY"]));
      }
      weaponList.add(weapon);
    }
    return weaponList;
  }

  static Future<List<Armour>> _createArmour(json) async {
    List<Armour> armourList = [];
    for (var map in json ?? []) {
      Armour armour = await ArmourFactory().get(map["ID"]);
      map["HEAD_AP"] != null ? armour.headAP = map["HEAD_AP"] : null;
      map["body_AP"] != null ? armour.bodyAP = map["body_AP"] : null;
      map["left_arm_AP"] != null ? armour.leftArmAP = map["left_arm_AP"] : null;
      map["right_arm_AP"] != null ? armour.rightArmAP = map["right_arm_AP"] : null;
      map["left_leg_AP"] != null ? armour.leftLegAP = map["left_leg_AP"] : null;
      map["right_leg_AP"] != null ? armour.rightLegAP = map["right_leg_AP"] : null;
      armourList.add(armour);
    }
    return armourList;
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

  List<Talent> getTalents() {
    return List.of(talents.values);
  }

  @override
  String toString() {
    return "Character (name=$name, race=$race), profession=$profession";
  }
}
