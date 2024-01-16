import 'package:battle_it_out/utils/database_provider.dart';
import 'package:sqflite/sqflite.dart';

abstract class DAO {
  final Database database = DatabaseProvider.instance.database;

  get tableName;

  Future<int> getNextId() async {
    return ((await database.rawQuery("SELECT MAX(ID)+1 AS NEXT_ID FROM $tableName")).first["NEXT_ID"] ?? 1) as int;
  }

  Future<Map<String, Object?>> getMapWhere({String? where, List<Object>? whereArgs}) async {
    return (await database.query(tableName, where: where, whereArgs: whereArgs)).firstOrNull ?? {};
  }

  Future<List<Map<String, Object?>>> getMapAll({String? where, List<Object>? whereArgs}) async {
    return await database.query(tableName, where: where, whereArgs: whereArgs);
  }

  Future<void> insertMap(Map<String, Object?> map, [String? tableName]) async {
    database.insert(tableName ?? this.tableName, map, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> set(int id, Map<String, Object?> map) async {
    return await database.update(tableName, map, where: "ID = ?", whereArgs: [id]);
  }

  Future<int> deleteWhere({String? where, List<Object>? whereArgs}) async {
    return await database.delete(tableName, where: where, whereArgs: whereArgs);
  }

  Future<int> delete(int id) async {
    return await database.delete(tableName, where: "ID = ?", whereArgs: [id]);
  }
}
