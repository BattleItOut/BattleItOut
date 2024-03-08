import 'package:battle_it_out/providers/database_provider.dart';
import 'package:get_it/get_it.dart';
import 'package:logging/logging.dart';
import 'package:sqflite/sqflite.dart';

abstract mixin class DAO {
  late final Database database = GetIt.instance.get<DatabaseRepository>().database;
  final Logger log = Logger("DB");
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

  Future<List<Map<String, Object?>>> getRawQuery({required String sql, List<Object?>? sqlArgs}) async {
    var result = (await database.rawQuery(sql, sqlArgs));
    log.log(Level.FINE, "SELECT RAW QUERY ($sql $sqlArgs): $result");
    return result;
  }

  Future<List<Map<String, Object?>>> getMapAll({String? where, List<Object>? whereArgs}) async {
    var result = await database.query(tableName, where: where, whereArgs: whereArgs);
    log.log(Level.FINE, "SELECT ALL (where: $where $whereArgs, from: $tableName): $result");
    return result;
  }

  Future<int> updateMap(Map<String, Object?> map, [String? tableName]) async {
    var result = await database.insert(tableName ?? this.tableName, map, conflictAlgorithm: ConflictAlgorithm.replace);
    log.log(Level.FINE, "UPDATE ($map, to: ${tableName ?? this.tableName}): $result");
    return result;
  }

  Future<int> set(int id, Map<String, Object?> map) async {
    var result = await database.update(tableName, map, where: "ID = ?", whereArgs: [id]);
    log.log(Level.FINE, "UPDATE ($map, where: ID = ?, whereArgs: $id, in: $tableName): $result");
    return result;
  }

  Future<int> deleteWhere({String? where, List<Object>? whereArgs}) async {
    var result = await database.delete(tableName, where: where, whereArgs: whereArgs);
    log.log(Level.FINE, "DELETE (where: $where $whereArgs, from: $tableName): $result");
    return result;
  }

  Future<int> deleteMap(int id) async {
    var result = await database.delete(tableName, where: "ID = ?", whereArgs: [id]);
    log.log(Level.FINE, "DELETE (where: ID = ?, whereArgs: $id, from: $tableName): $result");
    return result;
  }
}
