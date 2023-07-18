import 'package:battle_it_out/persistence/attribute.dart';
import 'package:battle_it_out/persistence/character/simple_character.dart';
import 'package:battle_it_out/persistence/item/armour.dart';
import 'package:battle_it_out/persistence/item/item.dart';
import 'package:battle_it_out/persistence/item/melee_weapon.dart';
import 'package:battle_it_out/persistence/item/ranged_weapon.dart';
import 'package:battle_it_out/persistence/profession/profession.dart';
import 'package:battle_it_out/persistence/serializer.dart';
import 'package:battle_it_out/persistence/skill/skill.dart';
import 'package:battle_it_out/persistence/subrace.dart';
import 'package:battle_it_out/persistence/talent/talent.dart';
import 'package:flutter/foundation.dart' hide Factory;

class Character extends SimpleCharacter {
  Character(
      {required super.name,
      super.description,
      required super.subrace,
      required super.profession,
      super.initiative,
      super.attributes,
      super.skills,
      super.talents,
      super.traits,
      super.items});

  static Character from(Character character) {
    var newInstance = Character(
        name: character.name,
        subrace: character.subrace,
        profession: character.profession,
        attributes: character.attributes);
    newInstance.skills = character.skills;
    newInstance.talents = character.talents;
    newInstance.initiative = character.initiative;
    return newInstance;
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
          listEquals(items, other.items) &&
          initiative == other.initiative;

  @override
  int get hashCode =>
      name.hashCode ^
      subrace.hashCode ^
      profession.hashCode ^
      attributes.hashCode ^
      skills.hashCode ^
      talents.hashCode ^
      items.hashCode ^
      initiative.hashCode;

  @override
  String toString() {
    return "Character (name=$name, subrace=$subrace, profession=$profession)";
  }
}

class CharacterFactory extends Factory<Character> {
  @override
  get tableName => 'skills';

  @override
  Future<Character> fromMap(dynamic json) async {
    String name = json['NAME'];
    Subrace subrace = await SubraceFactory().create(json["SUBRACE"]);
    Profession profession = await ProfessionFactory().create(json["PROFESSION"]);
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
