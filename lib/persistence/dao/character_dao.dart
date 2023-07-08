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
    List<Attribute> attributes = await _createAttributes(json["ATTRIBUTES"]);
    List<Skill> skills = await _createSkills(json['SKILLS'] ?? [], attributes);
    List<Talent> talents = [for (var map in json['TALENTS'] ?? []) await TalentFactory(attributes, skills).create(map)];

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
        for (Attribute attribute in object.attributes.where((element) => element.base != 0))
          await AttributeFactory().toMap(attribute)
      ],
      "SKILLS": [
        for (Skill skill in object.skills.where((element) => element.advances != 0 || element.canAdvance || element.earning))
          await SkillFactory().toMap(skill)
      ],
      "TALENTS": [for (Talent talent in object.talents) await TalentFactory().toMap(talent)],
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

  static Future<List<Attribute>> _createAttributes(json) async {
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

  static Future<List<Skill>> _createSkills(json, List<Attribute> attributes) async {
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
