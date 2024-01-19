import 'dart:developer';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:yaml/yaml.dart';

class DatabaseProvider {
  static final DatabaseProvider _instance = DatabaseProvider._();
  static DatabaseProvider get instance => _instance;
  Database get database => _database!;
  Database? _database;
  String? _dbPath;
  String? _insertScript;

  DatabaseProvider._() {
    if (Platform.isWindows || Platform.isLinux) {
      sqfliteFfiInit();
      databaseFactoryOrNull = databaseFactoryFfi;
      log("Using sqflite_ffi");
    } else {
      log("Using sqflite");
    }
  }

  Future<void> connect({test = false}) async {
    if (test) {
      _dbPath = inMemoryDatabasePath;
      _insertScript = File("assets/test/database_inserts.sql").readAsStringSync();
    } else {
      _dbPath = join(await getDatabasesPath(), 'data.db');
    }
    log("Connecting the database on $_dbPath...");

    if (await Directory("assets/database_module/resources").exists()) {
      log("Coping database scripts from module");
      File("assets/database_module/resources/database/database_structure.sql")
          .copySync("assets/database_structure.sql");
      File("assets/database_module/resources/database/database.version").copySync("assets/database.version");
      if (!test) {
        _insertScript = File("assets/database_module/resources/database/database_inserts.sql").readAsStringSync();
      }
    }

    YamlMap parsedYaml = loadYaml(await rootBundle.loadString("assets/database.version"));
    var major = "${parsedYaml["MAJOR"]}".padLeft(1, "0");
    var minor = "${parsedYaml["MINOR"]}".padLeft(2, "0");
    var version = "${parsedYaml["VERSION"]}".padLeft(3, "0");
    var intVersion = int.parse(major + minor + version);

    _database = await databaseFactory.openDatabase(
      _dbPath!,
      options: OpenDatabaseOptions(
        version: intVersion,
        singleInstance: true,
        onCreate: (Database db, int version) async {
          log("Creating database");
          BatchManager.execute(await rootBundle.loadString("assets/database_structure.sql"), db);
          if (_insertScript != null) {
            BatchManager.execute(_insertScript!, db);
          }
          log("Database created, version: $intVersion");
        },
        onUpgrade: (Database db, int lastVersion, int version) {
          log("Migrating $lastVersion to $version");
        },
        onOpen: (Database db) async {
          log("Opening database, version: ${await db.getVersion()}");
        },
      ),
    );
  }
}

class BatchManager {
  BatchManager._();

  static void execute(String script, Database database) {
    var component = BatchManager._();
    Batch batch = database.batch();
    component._open(script, batch);
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

  void _open(String dbCreateString, Batch batch) {
    String command = "";
    for (String line in dbCreateString.split("\n")) {
      line = line.trim();
      command = "$command $line";
      if (line != "" && line[line.length - 1] == ";") {
        _register(command.trim(), batch);
        command = "";
      }
    }
  }
}
