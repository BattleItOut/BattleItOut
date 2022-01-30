import 'dart:io';

import 'package:battle_it_out/persistence/DTO/attribute.dart';
import 'package:battle_it_out/persistence/DTO/profession.dart';
import 'package:battle_it_out/persistence/DTO/talent.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';


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
    final List<Map<String, dynamic>> map = await _database!.query("attributes",
        where: "ATTRIBUTES.ID = ?",
        whereArgs: [id]);

    return Attribute(
        id: map[0]['ID'],
        name: map[0]['NAME'],
        rollable: map[0]['ROLLABLE'],
        importance: map[0]['IMPORTANCE']);
  }

  Future<ProfessionClass> getProfessionClass(int id) async {
    final List<Map<String, dynamic>> map = await _database!.query("professions_classes",
        where: "PROFESSIONS_CLASSES.ID = ?",
        whereArgs: [id]);

    return ProfessionClass(
        id: map[0]["ID"],
        name: map[0]["NAME"]);
  }
  Future<ProfessionCareer> getProfessionCareer(int id) async {
    final List<Map<String, dynamic>> map = await _database!.query("professions_careers",
        where: "PROFESSIONS_CAREERS.CAREER_ID = ?",
        whereArgs: [id]);

    return ProfessionCareer(
        id: map[0]["CAREER_ID"],
        name: map[0]["NAME"],
        professionClass: await getProfessionClass(map[0]["CLASS_ID"]));
  }
  Future<Profession> getProfession(int id) async {
    final List<Map<String, dynamic>> map = await _database!.query("professions",
        where: "PROFESSIONS.PROFESSION_ID = ?",
        whereArgs: [id]);

    return Profession(
        id: map[0]["PROFESSION_ID"],
        name: map[0]["NAME"],
        nameEng: map[0]["NAME_ENG"],
        level: map[0]["LEVEL"],
        source: map[0]["SRC"],
        career: await getProfessionCareer(map[0]["CAREER_ID"]));
  }

  Future<List<Talent>> getTalents() async {
    final List<Map<String, dynamic>> maps = await _database!.query("talents");

    return List.generate(maps.length, (i) {
      return Talent(
        id: maps[i]['ID'],
        name: maps[i]['NAME'],
        nameEng: maps[i]['NAME_ENG'],
        maxLvl: maps[i]['MAX_LVL'],
        constLvl: maps[i]['CONST_LVL'],
        descr: maps[i]['DESCR'],
        grouped: maps[i]['GROUPED']);
    });
  }
}