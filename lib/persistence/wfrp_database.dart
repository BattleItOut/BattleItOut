import 'package:battle_it_out/persistence/dao/item_quality_dao.dart';
import 'package:battle_it_out/persistence/dao/skill_dao.dart';
import 'package:battle_it_out/persistence/entities/armour.dart';
import 'package:battle_it_out/persistence/entities/attribute.dart';
import 'package:battle_it_out/persistence/entities/item_quality.dart';
import 'package:battle_it_out/persistence/entities/melee_weapon.dart';
import 'package:battle_it_out/persistence/entities/ranged_weapon.dart';
import 'package:battle_it_out/persistence/entities/skill.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class WFRPDatabase {
  Database? database;

  static Future<WFRPDatabase> create(String dbCreateFile) async {
    var component = WFRPDatabase();
    print("Database initiated.");
    component.database = await _connect(dbCreateFile);
    print("Database loaded.");
    return component;
  }

  static Future<Database> _connect(String dbCreateFile) async {
    var dbDir = await getDatabasesPath();
    var dbPath = join(dbDir, "database.sqlite");
    List<String> commands = await _splitCommands(dbCreateFile);

    // Delete any existing database:
    await deleteDatabase(dbPath);

    return await openDatabase(dbPath, version: 1, onCreate: (Database db, int version) async {
      for (String command in commands) {
        await db.execute(command);
      }
    });
  }

  static Future<List<String>> _splitCommands(String dbCreateFile) async {
    String dbCreateString = await rootBundle.loadString(dbCreateFile);
    List<String> commands = [];
    String command = "";
    for (String line in dbCreateString.split("\n")) {
      line = line.trim();
      command = command + " " + line;
      if (line != "" && line[line.length - 1] == ";") {
        commands.add(command.trim());
        command = "";
      }
    }
    return commands;
  }

  Future<List<ItemQuality>> getArmourQualities(int id) async {
    final List<Map<String, dynamic>> map =
        await database!.query("armour_qualities", where: "ARMOUR_QUALITIES.ARMOUR_ID = ?", whereArgs: [id]);
    List<ItemQuality> qualities = [];
    for (int i = 0; i < map.length; i++) {
      qualities.add(await ItemQualityDAO().get(this, map[i]["QUALITY_ID"]));
    }
    return qualities;
  }

  Future<List<ItemQuality>> getMeleeWeaponQualities(int id) async {
    final List<Map<String, dynamic>> map = await database!
        .query("weapons_melee_qualities", where: "WEAPONS_MELEE_QUALITIES.WEAPON_ID = ?", whereArgs: [id]);
    List<ItemQuality> qualities = [];
    for (int i = 0; i < map.length; i++) {
      qualities.add(await ItemQualityDAO().get(this, map[i]["QUALITY_ID"]));
    }
    return qualities;
  }

  Future<List<ItemQuality>> getRangedWeaponQualities(int id) async {
    final List<Map<String, dynamic>> map = await database!
        .query("weapons_ranged_qualities", where: "WEAPONS_RANGED_QUALITIES.WEAPON_ID = ?", whereArgs: [id]);
    List<ItemQuality> qualities = [];
    for (int i = 0; i < map.length; i++) {
      qualities.add(await ItemQualityDAO().get(this, map[i]["QUALITY_ID"]));
    }
    return qualities;
  }

  Future<Armour> getArmour(int id) async {
    final List<Map<String, dynamic>> map = await database!.query("armour", where: "ARMOUR.ID = ?", whereArgs: [id]);

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
        await database!.query("weapons_melee", where: "WEAPONS_MELEE.ID = ?", whereArgs: [id]);

    MeleeWeapon weapon = MeleeWeapon(
        id: map[0]["ID"],
        name: map[0]["NAME"],
        length: map[0]["LENGTH"],
        damage: map[0]["DAMAGE"],
        skill: skills[map[0]['SKILL']] ?? await SkillDAO(attributes).get(this, map[0]['SKILL']),
        qualities: await getMeleeWeaponQualities(id));
    return weapon;
  }

  Future<RangedWeapon> getRangedWeapon(int id, Map<int, Skill> skills, Map<int, Attribute> attributes) async {
    final List<Map<String, dynamic>> map =
        await database!.query("weapons_ranged", where: "WEAPONS_RANGED.ID = ?", whereArgs: [id]);

    return RangedWeapon(
        id: map[0]["ID"],
        name: map[0]["NAME"],
        range: map[0]["WEAPON_RANGE"],
        damage: map[0]["DAMAGE"],
        strengthBonus: map[0]["STRENGTH_BONUS"] == 1,
        skill: skills[map[0]['SKILL']] ?? await SkillDAO(attributes).get(this, map[0]['SKILL']),
        qualities: await getRangedWeaponQualities(id));
  }
}
