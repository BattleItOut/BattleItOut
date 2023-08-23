import 'package:battle_it_out/utils/database_provider.dart';
import 'package:sqflite/sqflite.dart';

abstract class DAO {
  get tableName;

  Future<int> getNextId() async {
    Database? database = await DatabaseProvider.instance.getDatabase();

    Map<String, Object?>? list = (await database.rawQuery("SELECT MAX(ID)+1 AS NEXT_ID FROM $tableName")).firstOrNull;
    return (list?["NEXT_ID"] as int?) ?? 1;
  }

  Future<Map<String, Object?>> getMapWhere({String? where, List<Object>? whereArgs}) async {
    Database? database = await DatabaseProvider.instance.getDatabase();

    List<Map<String, Object?>> list = (await database.query(tableName, where: where, whereArgs: whereArgs));
    return list.firstOrNull ?? {};
  }

  Future<List<Map<String, Object?>>> getMapAll({String? where, List<Object>? whereArgs}) async {
    Database? database = await DatabaseProvider.instance.getDatabase();

    return await database.query(tableName, where: where, whereArgs: whereArgs);
  }

  Future<void> insertMap(Map<String, Object?> map, [String? tableName]) async {
    Database? database = await DatabaseProvider.instance.getDatabase();

    database.insert(tableName ?? this.tableName, map);
  }

  Future<int> set(int id, Map<String, Object?> map) async {
    Database? database = await DatabaseProvider.instance.getDatabase();

    return await database.update(tableName, map, where: "ID = ?", whereArgs: [id]);
  }

  Future<int> delete(int id) async {
    Database? database = await DatabaseProvider.instance.getDatabase();

    return await database.delete(tableName, where: "ID = ?", whereArgs: [id]);
  }
}
