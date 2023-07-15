import 'package:battle_it_out/persistence/dao/attribute_dao.dart';
import 'package:battle_it_out/persistence/dao/item/armour_dao.dart';
import 'package:battle_it_out/persistence/dao/item/item_dao.dart';
import 'package:battle_it_out/persistence/dao/item/melee_weapon_dao.dart';
import 'package:battle_it_out/persistence/dao/item/ranged_weapon_dao.dart';
import 'package:battle_it_out/persistence/dao/profession_dao.dart';
import 'package:battle_it_out/persistence/dao/race_dao.dart';
import 'package:battle_it_out/persistence/dao/serializer.dart';
import 'package:battle_it_out/persistence/dao/skill_dao.dart';
import 'package:battle_it_out/persistence/dao/talent_dao.dart';
import 'package:battle_it_out/persistence/entities/attribute.dart';
import 'package:battle_it_out/persistence/entities/character/character.dart';
import 'package:battle_it_out/persistence/entities/item/item.dart';
import 'package:battle_it_out/persistence/entities/profession.dart';
import 'package:battle_it_out/persistence/entities/race.dart';
import 'package:battle_it_out/persistence/entities/skill.dart';
import 'package:battle_it_out/persistence/entities/talent.dart';

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
