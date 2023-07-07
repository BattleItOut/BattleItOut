import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DatabaseProvider {
  static final DatabaseProvider _instance = DatabaseProvider._();
  Database? _database;

  DatabaseProvider._();

  static DatabaseProvider get instance => _instance;

  Future<Database> getDatabase() async {
    _database ??= await _connect();
    return _database!;
  }

  static Future<Database> _connect() async {
    if (Platform.isWindows || Platform.isLinux) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }
    Database database = await databaseFactory.openDatabase(inMemoryDatabasePath,
        options: OpenDatabaseOptions(
            version: 1,
            onCreate: (Database db, int version) async =>
                await BatchManager.execute("assets/database/create_db.sql", db)));
    if (kDebugMode) {
      print("Database loaded");
    }
    return database;
  }
}

class BatchManager {
  BatchManager._();

  static Future<void> execute(String script, Database database) async {
    var component = BatchManager._();
    Batch batch = database.batch();
    await component._open(script, batch);
    batch.commit(continueOnError: true);
  }

  void _register(String line, Batch batch) {
    RegExp insertRegex = RegExp(r'INSERT INTO ".*" VALUES(.*)');
    RegExp valReg = RegExp(r'VALUES(.*)');
    if (insertRegex.hasMatch(line)) {
      var match = valReg.firstMatch(line);
      List<dynamic> data = line.substring(match!.start + 7, match.end - 2).replaceAll("'", "").split(",");
      var parsedData = [for (var object in data) _parseString(object)];
      var parsedInsert = line.replaceAll(valReg, "VALUES(${[for (int i = 0; i < data.length; i++) "?"].join(", ")})");
      batch.rawInsert(parsedInsert, parsedData);
    } else {
      batch.execute(line);
    }
  }

  dynamic _parseString(String string) {
    if (string == "NULL") {
      return null;
    }
    return int.tryParse(string) ?? string;
  }

  Future<void> _open(String dbCreateFile, Batch batch) async {
    String dbCreateString = await rootBundle.loadString(dbCreateFile);
    String command = "";
    for (String line in dbCreateString.split("\n")) {
      line = line.trim();
      command = command + " " + line;
      if (line != "" && line[line.length - 1] == ";") {
        _register(command.trim(), batch);
        command = "";
      }
    }
  }
}
