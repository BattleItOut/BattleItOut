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
import 'package:battle_it_out/utils/database_provider.dart';
import 'package:battle_it_out/utils/db_object.dart';
import 'package:battle_it_out/utils/serializer.dart';
import 'package:flutter/foundation.dart' hide Factory;
import 'package:sqflite/sqflite.dart';

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
  Future<Character> fromDatabase(dynamic json) async {
    int? id = json['ID'];
    String name = json['NAME'];
    Size? size = await SizeFactory().getNullable(json["SIZE"]);
    Subrace? subrace = await SubraceFactory().getNullable(json["ANCESTRY"]);
    Profession? profession = await ProfessionFactory().get(json["PROFESSION"]);
    List<Attribute> attributes = await getCharactersAttributes(json['ID']);
    List<Skill> skills = await _createSkills(json['SKILLS'] ?? [], attributes);
    List<Talent> talents = [
      for (var map in json['TALENTS'] ?? []) await TalentFactory(attributes, skills).fromDatabase(map)
    ];
    List<Item> items = [
      for (var map in json["MELEE_WEAPONS"] ?? []) await MeleeWeaponFactory(attributes, skills).fromDatabase(map),
      for (var map in json["RANGED_WEAPONS"] ?? []) await RangedWeaponFactory(attributes, skills).fromDatabase(map),
      for (var map in json["ARMOUR"] ?? []) await ArmourFactory().fromDatabase(map),
      for (var map in json["ITEMS"] ?? []) await CommonItemFactory().fromDatabase(map)
    ];

    return Character(
        id: id,
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
  Future<Character> fromMap(dynamic map) async {
    String name = map['NAME'];
    Size? size = map["SIZE"] != null ? await SizeFactory().get(map["SIZE"]) : null;
    Subrace? subrace = map["SUBRACE"] != null ? await SubraceFactory().create(map["SUBRACE"]) : null;
    Profession? profession = map["PROFESSION"] != null ? await ProfessionFactory().create(map["PROFESSION"]) : null;
    List<Attribute> attributes = await _createAttributes(map["ATTRIBUTES"]);
    List<Skill> skills = await _createSkills(map['SKILLS'] ?? [], attributes);
    List<Talent> talents = [
      for (var talentMap in map['TALENTS'] ?? []) await TalentFactory(attributes, skills).create(talentMap)
    ];
    List<Item> items = [
      for (var meleeWeaponMap in map["MELEE_WEAPONS"] ?? [])
        await MeleeWeaponFactory(attributes, skills).create(meleeWeaponMap),
      for (var rangedWeaponMap in map["RANGED_WEAPONS"] ?? [])
        await RangedWeaponFactory(attributes, skills).create(rangedWeaponMap),
      for (var armourMap in map["ARMOUR"] ?? []) await ArmourFactory().create(armourMap),
      for (var itemMap in map["ITEMS"] ?? []) await CommonItemFactory().create(itemMap)
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
  Future<Map<String, Object?>> toDatabase(Character object) async {
    return {
      "NAME": object.name,
      "SUBRACE": await SubraceFactory().toDatabase(object.subrace!),
      "PROFESSION": await ProfessionFactory().toDatabase(object.profession!),
      "ATTRIBUTES": [for (var attribute in object.attributes) await AttributeFactory().toDatabase(attribute)],
      "SKILLS": [for (var skill in object.skills.where((s) => s.isImportant())) await SkillFactory().toDatabase(skill)],
      "TALENTS": [for (var talent in object.talents) await TalentFactory().toDatabase(talent)],
      "MELEE_WEAPONS": [for (var weapon in object.getMeleeWeapons()) await MeleeWeaponFactory().toDatabase(weapon)],
      "RANGED_WEAPONS": [for (var weapon in object.getRangedWeapons()) await RangedWeaponFactory().toDatabase(weapon)],
      "ARMOUR": [for (var armour in object.getArmour()) await ArmourFactory().toDatabase(armour)],
    };
  }

  @override
  Future<Map<String, dynamic>> toMap(Character object, {optimised = true, database = false}) async {
    Map<String, dynamic> map = {
      "NAME": object.name,
      "SUBRACE": await SubraceFactory().toDatabase(object.subrace!),
      "PROFESSION": await ProfessionFactory().toDatabase(object.profession!),
      "ATTRIBUTES": [for (var attribute in object.attributes) await AttributeFactory().toDatabase(attribute)],
      "SKILLS": [for (var skill in object.skills.where((s) => s.isImportant())) await SkillFactory().toDatabase(skill)],
      "TALENTS": [for (var talent in object.talents) await TalentFactory().toDatabase(talent)],
      "MELEE_WEAPONS": [for (var weapon in object.getMeleeWeapons()) await MeleeWeaponFactory().toDatabase(weapon)],
      "RANGED_WEAPONS": [for (var weapon in object.getRangedWeapons()) await RangedWeaponFactory().toDatabase(weapon)],
      "ARMOUR": [for (var armour in object.getArmour()) await ArmourFactory().toDatabase(armour)],
    };
    if (optimised) {
      map = await optimise(map);
    }
    return map;
  }

  Future<List<Attribute>> getCharactersAttributes(int characterId) async {
    Database? database = await DatabaseProvider.instance.getDatabase();

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
