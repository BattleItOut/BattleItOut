import 'package:battle_it_out/utils/database_provider.dart';
import 'package:logging/logging.dart';
import 'package:sqflite/sqflite.dart';

abstract class DAO {
  final Database database = DatabaseProvider.instance.database;
  static Logger log = Logger("DB");
  get tableName;

  Future<int> getNextId() async {
    var result =
        ((await database.rawQuery("SELECT MAX(ID)+1 AS NEXT_ID FROM $tableName")).first["NEXT_ID"] ?? 1) as int;
    log.log(Level.FINE, "SELECT (NEXT_ID, from: $tableName): $result");
    return result;
  }

  Future<Map<String, Object?>> getMapWhere({String? where, List<Object>? whereArgs}) async {
    var result = (await database.query(tableName, where: where, whereArgs: whereArgs)).firstOrNull ?? {};
    log.log(Level.FINE, "SELECT (where: $where, whereArgs: $whereArgs, from: $tableName): $result");
    return result;
  }

  Future<List<Map<String, Object?>>> getMapAll({String? where, List<Object>? whereArgs}) async {
    var result = await database.query(tableName, where: where, whereArgs: whereArgs);
    log.log(Level.FINE, "SELECT ALL (where: $where, whereArgs: $whereArgs, from: $tableName): $result");
    return result;
  }

  Future<int> insertMap(Map<String, Object?> map, [String? tableName]) async {
    var result = database.insert(tableName ?? this.tableName, map, conflictAlgorithm: ConflictAlgorithm.replace);
    log.log(Level.FINE, "INSERT ($map, to: $tableName): $result");
    return result;
  }

  Future<int> set(int id, Map<String, Object?> map) async {
    var result = await database.update(tableName, map, where: "ID = ?", whereArgs: [id]);
    log.log(Level.FINE, "UPDATE ($map, where: ID = ?, whereArgs: $id, in: $tableName): $result");
    return result;
  }

  Future<int> deleteWhere({String? where, List<Object>? whereArgs}) async {
    var result = await database.delete(tableName, where: where, whereArgs: whereArgs);
    log.log(Level.FINE, "DELETE (where: $where, whereArgs: $whereArgs, from: $tableName): $result");
    return result;
  }

  Future<int> delete(int id) async {
    var result = await database.delete(tableName, where: "ID = ?", whereArgs: [id]);
    log.log(Level.FINE, "DELETE (where: ID = ?, whereArgs: $id, from: $tableName): $result");
    return result;
  }
}
