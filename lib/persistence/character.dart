import 'package:battle_it_out/persistence/dao/armour_dao.dart';
import 'package:battle_it_out/persistence/dao/attribute_dao.dart';
import 'package:battle_it_out/persistence/dao/melee_weapon_dao.dart';
import 'package:battle_it_out/persistence/dao/profession_dao.dart';
import 'package:battle_it_out/persistence/dao/race_dao.dart';
import 'package:battle_it_out/persistence/dao/ranged_weapon_dao.dart';
import 'package:battle_it_out/persistence/dao/skill_dao.dart';
import 'package:battle_it_out/persistence/dao/talent_dao.dart';
import 'package:battle_it_out/persistence/entities/armour.dart';
import 'package:battle_it_out/persistence/entities/attribute.dart';
import 'package:battle_it_out/persistence/entities/item.dart';
import 'package:battle_it_out/persistence/entities/melee_weapon.dart';
import 'package:battle_it_out/persistence/entities/profession.dart';
import 'package:battle_it_out/persistence/entities/race.dart';
import 'package:battle_it_out/persistence/entities/ranged_weapon.dart';
import 'package:battle_it_out/persistence/entities/skill.dart';
import 'package:battle_it_out/persistence/entities/talent.dart';
import 'package:flutter/foundation.dart';

class Character {
  String name;
  Race? race;
  Profession? profession;
  Map<int, Attribute> attributes;
  Map<int, Skill> skills;
  Map<int, Talent> talents = {};

  List<Item> items = [];
  int? initiative;
  // List<Trait> traits;

  Character(
      {required this.name,
      this.race,
      this.profession,
      this.attributes = const {},
      this.skills = const {},
      this.talents = const {},
      List<Item> items = const []}) {
    this.items.addAll(items);
  }

  static Character from(Character character) {
    var newInstance = Character(
        name: character.name,
        race: character.race,
        profession: character.profession,
        attributes: character.attributes);
    newInstance.skills = character.skills;
    newInstance.talents = character.talents;
    newInstance.initiative = character.initiative;
    return newInstance;
  }

  static Future<Character> create(dynamic json) async {
    String name = json['NAME'];
    Race race = await RaceFactory().create(json["RACE"]);
    Profession profession =
        await ProfessionFactory().create(json["PROFESSION"]);
    Map<int, Attribute> attributes =
        await _createAttributes(json["ATTRIBUTES"]);
    Map<int, Skill> skills =
        await _createSkills(json['SKILLS'] ?? [], attributes);
    Map<int, Talent> talents =
        await _createTalents(json['TALENTS'] ?? [], attributes);

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

  static Future<Map<int, Skill>> _createSkills(
      json, Map<int, Attribute> attributes) async {
    Map<int, Skill> skills = {
      for (Skill skill
          in await SkillFactory(attributes).getSkills(advanced: false))
        skill.id: skill
    };
    for (var map in json ?? []) {
      Skill skill = await SkillFactory(attributes).create(map);
      skills[skill.id] = skill;
    }
    return skills;
  }

  static Future<Map<int, Talent>> _createTalents(
      json, Map<int, Attribute> attributes) async {
    Map<int, Talent> talents = {};
    for (var map in json ?? []) {
      Talent talent = await TalentFactory(attributes).create(map);
      talents[talent.id] = talent;
    }
    return talents;
  }

  void addItem(Item item) {
    int index = items.indexOf(item);
    if (index == -1) {
      items.add(item);
    } else {
      items[index].count += 1;
    }
  }

  void addItems(List<Item> items) {
    for (Item item in items) {
      addItem(item);
    }
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

  // Melee weapons
  List<MeleeWeapon> getMeleeWeapons() {
    return items
        .where((i) => i.category != null && i.category == "MELEE_WEAPONS")
        .cast<MeleeWeapon>()
        .toList();
  }

  Map<Skill, List<MeleeWeapon>> getMeleeWeaponsGrouped() {
    Map<Skill, List<MeleeWeapon>> output = {};
    for (MeleeWeapon meleeWeapon in getMeleeWeapons()) {
      var category = meleeWeapon.skill!;
      if (output.containsKey(category)) {
        output[category]!.add(meleeWeapon);
      } else {
        output[category] = [meleeWeapon];
      }
    }
    return output;
  }

  // Ranged weapons
  List<RangedWeapon> getRangedWeapons() {
    return items
        .where((i) => i.category != null && i.category == "RANGED_WEAPONS")
        .cast<RangedWeapon>()
        .toList();
  }

  Map<Skill, List<RangedWeapon>> getRangedWeaponsGrouped() {
    Map<Skill, List<RangedWeapon>> output = {};
    for (RangedWeapon weapon in getRangedWeapons()) {
      var category = weapon.skill!;
      if (output.containsKey(category)) {
        output[category]!.add(weapon);
      } else {
        output[category] = [weapon];
      }
    }
    return output;
  }

  // Armour
  List<Armour> getArmour() {
    return items
        .where((i) => i.category != null && i.category == "ARMOUR")
        .cast<Armour>()
        .toList();
  }

  // Items
  Map<String, Map<Item, int>> getCommonItemsGrouped() {
    Map<String, Map<Item, int>> output = {};
    for (Item item in items) {
      String category = item.category ?? "NONE";
      if (output.containsKey(category)) {
        output[category]![item] = item.count;
      } else {
        output[category] = {item: item.count};
      }
    }
    return output;
  }

  Future<Map<String, dynamic>> toMap() async {
    List meleeWeapons = [];
    for (MeleeWeapon weapon in getMeleeWeapons()) {
      meleeWeapons.add(await MeleeWeaponFactory().toMap(weapon));
    }

    List rangedWeapons = [];
    for (RangedWeapon weapon in getRangedWeapons()) {
      rangedWeapons.add(await RangedWeaponFactory().toMap(weapon));
    }

    List armourList = [];
    for (Armour armour in getArmour()) {
      armourList.add(await ArmourFactory().toMap(armour));
    }

    Map<String, dynamic> map = {
      "NAME": name,
      "ATTRIBUTES": [for (Attribute attribute in attributes.values.where((element) => element.base != 0)) await AttributeFactory().toMap(attribute)],
      "SKILLS": [for (Skill skill in skills.values.where((element) => element.advances != 0 || element.advancable || element.earning)) await SkillFactory().toMap(skill)],
      "TALENTS": [for (Talent talent in talents.values) await TalentFactory().toMap(talent)],
      "MELEE_WEAPONS": [for (MeleeWeapon weapon in meleeWeapons) await MeleeWeaponFactory().toMap(weapon)],
      "RANGED_WEAPONS": [for (RangedWeapon weapon in rangedWeapons) await RangedWeaponFactory().toMap(weapon)],
      "ARMOUR": [for (Armour armour in this.armour) await ArmourFactory().toMap(armour)],
      "ATTRIBUTES": [
        for (Attribute attribute
            in attributes.values.where((element) => element.base != 0))
          await AttributeFactory().toMap(attribute)
      ],
      "SKILLS": [
        for (Skill skill in skills.values.where((element) =>
            element.advances != 0 || element.advancable || element.earning))
          await SkillFactory().toMap(skill)
      ],
      "TALENTS": [
        for (Talent talent in talents.values)
          await TalentFactory().toMap(talent)
      ],
      "MELEE_WEAPONS": meleeWeapons,
      "RANGED_WEAPONS": rangedWeapons,
      "ARMOUR": armourList,
    };
    if (race != null) {
      map["RACE"] = await RaceFactory().toMap(race!);
    }
    if (profession != null) {
      map["PROFESSION"] = await ProfessionFactory().toMap(profession!);
    }

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
          listEquals(items, other.items) &&
          initiative == other.initiative;

  @override
  int get hashCode =>
      name.hashCode ^
      race.hashCode ^
      profession.hashCode ^
      attributes.hashCode ^
      skills.hashCode ^
      talents.hashCode ^
      items.hashCode ^
      initiative.hashCode;

  @override
  String toString() {
    return "Character (name=$name, race=$race, profession=$profession)";
  }
}
