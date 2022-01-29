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
    return Attribute.fromMap(map[0]);
  }
  Future<Profession> getProfession(int id) async {
    final List<Map<String, dynamic>> map = await _database!.query("professions",
        where: "PROFESSIONS.PROFESSION_ID = ?",
        whereArgs: [id]);
    return Profession.fromMap(map[0]);
  }
  Future<List<Talent>> getTalents() async {
    final List<Map<String, dynamic>> maps = await _database!.query("talents");

    return List.generate(maps.length, (i) {
      return Talent.fromMap(maps[i]);
    });
  }
}