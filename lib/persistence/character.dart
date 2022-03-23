import 'package:battle_it_out/persistence/dao/armour_dao.dart';
import 'package:battle_it_out/persistence/dao/attribute_dao.dart';
import 'package:battle_it_out/persistence/dao/item_quality_dao.dart';
import 'package:battle_it_out/persistence/dao/length_dao.dart';
import 'package:battle_it_out/persistence/dao/melee_weapon_dao.dart';
import 'package:battle_it_out/persistence/dao/profession_dao.dart';
import 'package:battle_it_out/persistence/dao/race_dao.dart';
import 'package:battle_it_out/persistence/dao/ranged_weapon_dao.dart';
import 'package:battle_it_out/persistence/dao/size_dao.dart';
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
    String name = json['name'];
    Race race = await _createRace(json["race"]);
    Profession profession = await _createProfession(json["profession"]);
    Map<int, Attribute> attributes = await _createAttributes(json["attributes"], race, profession);
    Map<int, Skill> skills = await _createSkills(json['skills'], attributes);
    Map<int, Talent> talents = await _createTalents(json['talents'], attributes);
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

  static Future<Race> _createRace(json) async {
    Race? race;
    if (json["race_id"] != null) {
      race = await RaceDAO().get(json["race_id"], {"NAME": json["name"]});
    } else {
      race = Race(name: json["name"], size: await SizeDAO().get(json["size"]));
    }

    if (json["subrace"] != null) {
      race.subrace = await _createSubrace(json["subrace"]);
    } else {
      race.subrace = await RaceDAO().getDefaultSubrace(race.id);
    }
    return race;
  }

  static Future<Subrace> _createSubrace(json) async {
    if (json["subrace_id"] != null) {
      return await SubraceDAO().get(json["subrace_id"], {"NAME": json["name"]});
    } else {
      return Subrace(name: json["name"]);
    }
  }

  static Future<Profession> _createProfession(json) async {
    Profession? profession;
    if (json["profession_id"] != null) {
      profession = await ProfessionDAO().get(json["profession_id"], {"NAME": json["name"]});
    } else {
      profession = Profession(name: json["name"]);
    }
    return profession;
  }

  static Future<Map<int, Attribute>> _createAttributes(json, Race race, Profession profession) async {
    Map<int, Attribute> attributes = await race.getAttributes();
    for (var attributeMap in json) {
      if (attributes[attributeMap["id"]] == null) {
        attributes[attributeMap["id"]] = await AttributeDAO().get(attributeMap["id"]);
      }
      attributes[attributeMap["id"]]?.base = attributeMap["base"];
      attributes[attributeMap["id"]]?.advances = attributeMap["advances"] ?? 0;
    }
    return attributes;
  }

  static Future<List<RangedWeapon>> _createRangedWeapons(
      json, Map<int, Attribute> attributes, Map<int, Skill> skills) async {
    List<RangedWeapon> weaponList = [];
    for (var map in json ?? []) {
      RangedWeapon weapon = await RangedWeaponDTO(attributes, skills).get(map["weapon_id"]);
      weapon.ammunition = map["ammunition"] ?? 0;
      for (var qualityMap in map["qualities"] ?? []) {
        weapon.addQuality(await ItemQualityDAO().get(qualityMap["quality_id"]));
      }
      weaponList.add(weapon);
    }
    return weaponList;
  }

  static Future<List<MeleeWeapon>> _createMeleeWeapons(
      json, Map<int, Attribute> attributes, Map<int, Skill> skills) async {
    List<MeleeWeapon> weaponList = [];
    for (var map in json ?? []) {
      MeleeWeapon weapon = await MeleeWeaponDAO(attributes, skills).get(map["weapon_id"]);
      map["name"] != null ? weapon.name = map["name"] : null;
      map["length"] != null ? weapon.length = await WeaponLengthDAO().get(map["length"]) : null;
      for (var qualityMap in map["qualities"] ?? []) {
        weapon.addQuality(await ItemQualityDAO().get(qualityMap["quality_id"]));
      }
      weaponList.add(weapon);
    }
    return weaponList;
  }

  static Future<List<Armour>> _createArmour(json) async {
    List<Armour> armourList = [];
    for (var map in json ?? []) {
      Armour armour = await ArmourDAO().get(map["armour_id"]);
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

  static Future<Map<int, Skill>> _createSkills(json, Map<int, Attribute> attributes) async {
    Map<int, Skill> skillsMap = {};
    for (var map in json ?? []) {
      Skill skill = await SkillDAO(attributes).get(map["skill_id"]);
      map["advances"] != null ? skill.advances = map["advances"] : null;
      map["advancable"] != null ? skill.advancable = map["advancable"] : null;
      map["earning"] != null ? skill.earning = map["earning"] : null;
      skillsMap[skill.id] = skill;
    }
    for (Skill skill in await SkillDAO(attributes).getBasicSkills()) {
      skillsMap.putIfAbsent(skill.id, () => skill);
    }
    return skillsMap;
  }

  static Future<Map<int, Talent>> _createTalents(json, Map<int, Attribute> attributes) async {
    Map<int, Talent> talentsMap = {};
    for (var map in json ?? []) {
      Talent talent = await TalentDAO(attributes).get(map["talent_id"]);
      map["lvl"] != null ? talent.currentLvl = map["lvl"] : null;
      map["advancable"] != null ? talent.advancable = map["advancable"] : null;
      talentsMap[talent.id] = talent;
    }
    return talentsMap;
  }

  // List getters

  List<Attribute> getAttributes() {
    return List.of(attributes.values);
  }

  Map<String, List<Skill>> getBasicSkillsGrouped() {
    Map<String, List<Skill>> output = {};
    for (var skill in skills.values.where((skill) => !skill.isAdvanced())) {
      var category = skill.baseSkill!.name;
      if (output.containsKey(category)) {
        output[category]!.add(skill);
      } else {
        output[category] = [skill];
      }
    }
    return output;
  }
  Map<String, List<Skill>> getAdvancedSkillsGrouped() {
    Map<String, List<Skill>> output = {};
    for (var skill in skills.values.where((skill) => skill.isAdvanced())) {
      var category = skill.baseSkill!.name;
      if (output.containsKey(category)) {
        output[category]!.add(skill);
      } else {
        output[category] = [skill];
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
