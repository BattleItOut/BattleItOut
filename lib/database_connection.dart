import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'DTO/talent.dart';

Future<Database> dbConnect(String assetDBPath) async {
  var dbDir = await getDatabasesPath();
  var dbPath = join(dbDir, "database.sqlite");

  // Delete any existing database:
  await deleteDatabase(dbPath);

  // Create the writable database file from the bundled demo database file:
  ByteData data = await rootBundle.load(assetDBPath);
  List<int> bytes =
      data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  await File(dbPath).writeAsBytes(bytes);

  // Return database
  return await openDatabase(dbPath);
}

Future<List<Talent>> getTalents(Database database) async {
  final List<Map<String, dynamic>> maps = await database.query("talents");

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