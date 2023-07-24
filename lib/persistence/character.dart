import 'package:battle_it_out/persistence/attribute.dart';
import 'package:battle_it_out/persistence/item/armour.dart';
import 'package:battle_it_out/persistence/item/item.dart';
import 'package:battle_it_out/persistence/item/melee_weapon.dart';
import 'package:battle_it_out/persistence/item/ranged_weapon.dart';
import 'package:battle_it_out/persistence/profession/profession.dart';
import 'package:battle_it_out/persistence/serializer.dart';
import 'package:battle_it_out/persistence/size.dart';
import 'package:battle_it_out/persistence/skill/skill.dart';
import 'package:battle_it_out/persistence/skill/skill_base.dart';
import 'package:battle_it_out/persistence/subrace.dart';
import 'package:battle_it_out/persistence/talent/talent.dart';
import 'package:battle_it_out/persistence/talent/talent_base.dart';
import 'package:battle_it_out/persistence/trait.dart';
import 'package:flutter/foundation.dart' hide Factory;

class Character {
  int? id;
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

  // Temporary
  int? initiative;

  Character(
      {required this.name,
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
    return items.where((i) => i.category != null && i.category == "MELEE_WEAPONS").cast<MeleeWeapon>().toList();
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
    return items.where((i) => i.category != null && i.category == "RANGED_WEAPONS").cast<RangedWeapon>().toList();
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
    return items.where((i) => i.category != null && i.category == "ARMOUR").cast<Armour>().toList();
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

  static Character from(Character character) {
    return Character(
        name: character.name,
        subrace: character.subrace,
        profession: character.profession,
        attributes: character.attributes,
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
  Future<Character> fromMap(dynamic json) async {
    String name = json['NAME'];
    Size? size = json["SIZE"] != null ? await SizeFactory().get(json["SIZE"]) : null;
    Subrace? subrace = json["SUBRACE"] != null ? await SubraceFactory().create(json["SUBRACE"]) : null;
    Profession? profession = json["PROFESSION"] != null ? await ProfessionFactory().create(json["PROFESSION"]) : null;
    List<Attribute> attributes = await _createAttributes(json["ATTRIBUTES"]);
    List<Skill> skills = await _createSkills(json['SKILLS'] ?? [], attributes);
    List<Talent> talents = [for (var map in json['TALENTS'] ?? []) await TalentFactory(attributes, skills).create(map)];
    List<Item> items = [
      for (var map in json["MELEE_WEAPONS"] ?? []) await MeleeWeaponFactory(attributes, skills).create(map),
      for (var map in json["RANGED_WEAPONS"] ?? []) await RangedWeaponFactory(attributes, skills).create(map),
      for (var map in json["ARMOUR"] ?? []) await ArmourFactory().create(map),
      for (var map in json["ITEMS"] ?? []) await CommonItemFactory().create(map)
    ];

    return Character(
        name: name,
        size: size,
        subrace: subrace,
        profession: profession,
        attributes: attributes,
        skills: skills,
        talents: talents,
        items: items);
  }

  @override
  Future<Map<String, dynamic>> toMap(Character object, {optimised = true, database = false}) async {
    Map<String, dynamic> map = {
      "NAME": object.name,
      "SUBRACE": await SubraceFactory().toMap(object.subrace!),
      "PROFESSION": await ProfessionFactory().toMap(object.profession!),
      "ATTRIBUTES": [for (var attribute in object.attributes) await AttributeFactory().toMap(attribute)],
      "SKILLS": [for (var skill in object.skills.where((s) => s.isImportant())) await SkillFactory().toMap(skill)],
      "TALENTS": [for (var talent in object.talents) await TalentFactory().toMap(talent)],
      "MELEE_WEAPONS": [for (var weapon in object.getMeleeWeapons()) await MeleeWeaponFactory().toMap(weapon)],
      "RANGED_WEAPONS": [for (var weapon in object.getRangedWeapons()) await RangedWeaponFactory().toMap(weapon)],
      "ARMOUR": [for (var armour in object.getArmour()) await ArmourFactory().toMap(armour)],
    };
    if (optimised) {
      map = await optimise(map);
    }
    return map;
  }

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
