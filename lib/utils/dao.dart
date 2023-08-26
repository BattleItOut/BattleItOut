import 'package:battle_it_out/utils/database_provider.dart';
import 'package:sqflite/sqflite.dart';

abstract class DAO {
  final Database database = DatabaseProvider.instance.database;
  get tableName;

  Future<int> getNextId() async {
    Map<String, Object?>? list = (await database.rawQuery("SELECT MAX(ID)+1 AS NEXT_ID FROM $tableName")).firstOrNull;
    return (list?["NEXT_ID"] as int?) ?? 1;
  }

  Future<Map<String, Object?>> getMapWhere({String? where, List<Object>? whereArgs}) async {
    List<Map<String, Object?>> list = (await database.query(tableName, where: where, whereArgs: whereArgs));
    return list.firstOrNull ?? {};
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

  Future<int> delete(int id) async {
    return await database.delete(tableName, where: "ID = ?", whereArgs: [id]);
  }
}
