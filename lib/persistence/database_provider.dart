import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DatabaseProvider {
  Database? _database;
  static final DatabaseProvider _instance = DatabaseProvider._();
  DatabaseProvider._();

  static DatabaseProvider get instance => _instance;

  Future<Database?> getDatabase() async {
    _database ??= await _connect();
    return _database!;
  }

  static Future<Database> _connect() async {
    if (kDebugMode) {
      print("Database initiated");
    }

    var dbDir = await getApplicationDocumentsDirectory();
    var dbPath = join(dbDir.path, "database.sqlite");
    var dbFile = File(dbPath);

    if (await dbFile.exists()) {
      await dbFile.delete();
    }

    if (Platform.isWindows || Platform.isLinux) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }
    Database database = await databaseFactory.openDatabase(dbPath, options: OpenDatabaseOptions(version: 1, onCreate: (Database db, int version) async {
      for (String command in await _splitCommands("assets/database/create_db.sql")) {
        try {
          await db.execute(command);
        } on DatabaseException {
          // No need for logging because SQFLITE does it automatically
        }
      }
    }));

    if (kDebugMode) {
      print("Database loaded");
    }
    return database;
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
}
