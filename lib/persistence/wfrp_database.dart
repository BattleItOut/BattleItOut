import 'dart:io';

import 'package:battle_it_out/persistence/DTO/armour.dart';
import 'package:battle_it_out/persistence/DTO/attribute.dart';
import 'package:battle_it_out/persistence/DTO/item_quality.dart';
import 'package:battle_it_out/persistence/DTO/melee_weapon.dart';
import 'package:battle_it_out/persistence/DTO/profession.dart';
import 'package:battle_it_out/persistence/DTO/race.dart';
import 'package:battle_it_out/persistence/DTO/ranged_weapon.dart';
import 'package:battle_it_out/persistence/DTO/talent.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'DTO/skill.dart';

class WFRPDatabase {
  Database? _database;

  static Future<WFRPDatabase> create(String assetDBPath) async {
    var component = WFRPDatabase();
    component._database = await _connect(assetDBPath);
    return component;
  }

  static Future<Database> _connect(String assetDBPath) async {
    var dbDir = await getDatabasesPath();
    var dbPath = join(dbDir, "database.sqlite");

    // Delete any existing database:
    await deleteDatabase(dbPath);

    // Create the writable database file from the bundled demo database file:
    ByteData data = await rootBundle.load(assetDBPath);
    List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    await File(dbPath).writeAsBytes(bytes);

    // Return database
    return await openDatabase(dbPath);
  }

  Future<Attribute> getAttribute(int id) async {
    final List<Map<String, dynamic>> map =
        await _database!.query("attributes", where: "ATTRIBUTES.ID = ?", whereArgs: [id]);

    return Attribute(
        id: map[0]['ID'], name: map[0]['NAME'], rollable: map[0]['ROLLABLE'], importance: map[0]['IMPORTANCE']);
  }

  Future<Map<int, Attribute>> getAttributesByRace(int id) async {
    final List<Map<String, dynamic>> attributes =
        await _database!.query("race_attributes", where: "RACE_ATTRIBUTES.RACE_ID = ?", whereArgs: [id]);

    Map<int, Attribute> attributesList = {};
    for (var attributeMap in attributes) {
      Attribute attribute = await getAttribute(attributeMap['ATTR_ID']);
      attribute.base = attributeMap["VALUE"];
      attributesList[attribute.id] = attribute;
    }
    return attributesList;
  }

  Future<ProfessionClass> getProfessionClass(int id) async {
    final List<Map<String, dynamic>> map =
        await _database!.query("professions_classes", where: "PROFESSIONS_CLASSES.ID = ?", whereArgs: [id]);

    return ProfessionClass(id: map[0]["ID"], name: map[0]["NAME"]);
  }

  Future<ProfessionCareer> getProfessionCareer(int id) async {
    final List<Map<String, dynamic>> map =
        await _database!.query("professions_careers", where: "PROFESSIONS_CAREERS.CAREER_ID = ?", whereArgs: [id]);

    return ProfessionCareer(
        id: map[0]["CAREER_ID"], name: map[0]["NAME"], professionClass: await getProfessionClass(map[0]["CLASS_ID"]));
  }

  Future<Profession> getProfession(int id) async {
    final List<Map<String, dynamic>> map =
        await _database!.query("professions", where: "PROFESSIONS.PROFESSION_ID = ?", whereArgs: [id]);

    return Profession(
        id: map[0]["PROFESSION_ID"],
        name: map[0]["NAME"],
        nameEng: map[0]["NAME_ENG"],
        level: map[0]["LEVEL"],
        source: map[0]["SRC"],
        career: await getProfessionCareer(map[0]["CAREER_ID"]));
  }

  Future<Race> getRace(int id) async {
    final List<Map<String, dynamic>> map = await _database!.query("races", where: "RACES.ID = ?", whereArgs: [id]);

    return Race(
        id: map[0]["ID"],
        name: map[0]["NAME"],
        extraPoints: map[0]["EXTRA_POINTS"],
        size: map[0]["SIZE"],
        source: map[0]["SRC"]);
  }

  Future<Subrace> getSubrace(int id) async {
    final List<Map<String, dynamic>> map = await _database!.query("subraces", where: "ID = ?", whereArgs: [id]);

    return Subrace(
        id: map[0]["ID"],
        name: map[0]["NAME"],
        source: map[0]["SRC"],
        randomTalents: map[0]["RANDOM_TALENTS"],
        defaultSubrace: map[0]["DEF"] == 1);
  }

  Future<Talent> getTalent(int id, Map<int, Attribute> attributes) async {
    final List<Map<String, dynamic>> map = await _database!.query("talents", where: "ID = ?", whereArgs: [id]);

    return Talent(
        id: map[0]['ID'],
        name: map[0]['NAME'],
        nameEng: map[0]['NAME_ENG'],
        maxLvl: attributes[map[0]["MAX_LVL"]],
        constLvl: map[0]['CONST_LVL'],
        description: map[0]['DESCR'],
        grouped: map[0]['GROUPED'] == 1);
  }

  Future<List<Talent>> getTalents() async {
    final List<Map<String, dynamic>> maps = await _database!.query("talents");

    return List.generate(maps.length, (i) {
      return Talent(
          id: maps[i]['ID'],
          name: maps[i]['NAME'],
          nameEng: maps[i]['NAME_ENG'],
          constLvl: maps[i]['CONST_LVL'],
          description: maps[i]['DESCR'],
          grouped: maps[i]['GROUPED'] == 1);
    });
  }

  Future<Skill> getSkill(int id, Map<int, Attribute> attributes) async {
    final List<Map<String, dynamic>> map =
        await _database!.query("skills", where: "SKILLS.SKILL_ID = ?", whereArgs: [id]);

    return Skill(
        id: map[0]["SKILL_ID"],
        name: map[0]["NAME"],
        attribute: attributes[map[0]["ATTR_ID"]],
        description: map[0]["DESCR"],
        advanced: map[0]["ADV"] == 1,
        grouped: map[0]["GROUPED"] == 1,
        category: map[0]["CATEGORY"]);
  }

  Future<Map<int, Skill>> getSkillsByProfession(int id, Map<int, Attribute> attributes) async {
    final List<Map<String, dynamic>> skills =
        await _database!.query("prof_skills", where: "PROF_SKILLS.PROFESSION_ID = ?", whereArgs: [id]);

    Map<int, Skill> skillsMap = {};
    for (var map in skills) {
      Skill skill = await getSkill(map['SKILL_ID'], attributes);
      skill.earning = map["EARNING"] == 1;
      skillsMap[skill.id] = skill;
    }
    return skillsMap;
  }

  Future<ItemQuality> getQuality(int id) async {
    final List<Map<String, dynamic>> map =
        await _database!.query("item_qualities", where: "ITEM_QUALITIES.ID = ?", whereArgs: [id]);
    return ItemQuality(
        id: map[0]['ID'],
        name: map[0]['NAME'],
        nameEng: map[0]['NAME_ENG'],
        type: map[0]['TYPE'],
        equipment: map[0]['EQUIPMENT'],
        description: map[0]['DESCR'],
        value: map[0]["VALUE"]);
  }

  Future<List<ItemQuality>> getArmourQualities(int id) async {
    final List<Map<String, dynamic>> map =
        await _database!.query("armour_qualities", where: "ARMOUR_QUALITIES.ARMOUR_ID = ?", whereArgs: [id]);
    List<ItemQuality> qualities = [];
    for (int i = 0; i < map.length; i++) {
      qualities.add(await getQuality(map[i]["QUALITY_ID"]));
    }
    return qualities;
  }

  Future<List<ItemQuality>> getMeleeWeaponQualities(int id) async {
    final List<Map<String, dynamic>> map = await _database!
        .query("weapons_melee_qualities", where: "WEAPONS_MELEE_QUALITIES.WEAPON_ID = ?", whereArgs: [id]);
    List<ItemQuality> qualities = [];
    for (int i = 0; i < map.length; i++) {
      qualities.add(await getQuality(map[i]["QUALITY_ID"]));
    }
    return qualities;
  }

  Future<List<ItemQuality>> getRangedWeaponQualities(int id) async {
    final List<Map<String, dynamic>> map = await _database!
        .query("weapons_ranged_qualities", where: "WEAPONS_RANGED_QUALITIES.WEAPON_ID = ?", whereArgs: [id]);
    List<ItemQuality> qualities = [];
    for (int i = 0; i < map.length; i++) {
      qualities.add(await getQuality(map[i]["QUALITY_ID"]));
    }
    return qualities;
  }

  Future<Armour> getArmour(int id) async {
    final List<Map<String, dynamic>> map = await _database!.query("armour", where: "ARMOUR.ID = ?", whereArgs: [id]);

    return Armour(
        id: map[0]["ID"],
        name: map[0]["NAME"],
        headAP: map[0]["HEAD_AP"],
        bodyAP: map[0]["BODY_AP"],
        leftArmAP: map[0]["LEFT_ARM_AP"],
        rightArmAP: map[0]["RIGHT_ARM_AP"],
        leftLegAP: map[0]["LEFT_LEG_AP"],
        rightLegAP: map[0]["RIGHT_LEG_AP"],
        qualities: await getArmourQualities(id));
  }

  Future<MeleeWeapon> getMeleeWeapon(int id, Map<int, Skill> skills, Map<int, Attribute> attributes) async {
    final List<Map<String, dynamic>> map =
        await _database!.query("weapons_melee", where: "WEAPONS_MELEE.ID = ?", whereArgs: [id]);

    MeleeWeapon weapon = MeleeWeapon(
        id: map[0]["ID"],
        name: map[0]["NAME"],
        length: map[0]["LENGTH"],
        damage: map[0]["DAMAGE"],
        skill: skills[map[0]['SKILL']] ?? await getSkill(map[0]['SKILL'], attributes),
        qualities: await getMeleeWeaponQualities(id));
    return weapon;
  }

  Future<RangedWeapon> getRangedWeapon(int id, Map<int, Skill> skills, Map<int, Attribute> attributes) async {
    final List<Map<String, dynamic>> map =
        await _database!.query("weapons_ranged", where: "WEAPONS_RANGED.ID = ?", whereArgs: [id]);

    return RangedWeapon(
        id: map[0]["ID"],
        name: map[0]["NAME"],
        range: map[0]["WEAPON_RANGE"],
        damage: map[0]["DAMAGE"],
        strengthBonus: map[0]["STRENGTH_BONUS"] == 1,
        skill: skills[map[0]['SKILL']] ?? await getSkill(map[0]['SKILL'], attributes),
        qualities: await getRangedWeaponQualities(id));
  }
}
