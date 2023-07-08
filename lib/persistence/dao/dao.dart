import 'package:battle_it_out/persistence/database_provider.dart';
import 'package:sqflite/sqflite.dart';

abstract class DAO<T> {
  get tableName;

  Future<Map<String, dynamic>> getMap(int id) async {
    return getMapWhere(where: "ID = ?", whereArgs: [id]);
  }

  Future<Map<String, dynamic>> getMapWhere(
      {where, List<Object>? whereArgs}) async {
    Database? database = await DatabaseProvider.instance.getDatabase();

    return (await database.query(tableName,
        where: where, whereArgs: whereArgs))[0];
  }

  Future<List<Map<String, Object?>>> getMapAll(
      {String? where, List<Object>? whereArgs}) async {
    Database? database = await DatabaseProvider.instance.getDatabase();

    return await database.query(tableName, where: where, whereArgs: whereArgs);
  }

  Future<int> put(map) async {
    Database? database = await DatabaseProvider.instance.getDatabase();

    return await database.insert(tableName, map);
  }

  Future<int> set(int id, map) async {
    Database? database = await DatabaseProvider.instance.getDatabase();

    return await database
        .update(tableName, map, where: "ID = ?", whereArgs: [id]);
  }

  Future<int> delete(int id) async {
    Database? database = await DatabaseProvider.instance.getDatabase();

    return await database.delete(tableName, where: "ID = ?", whereArgs: [id]);
  }
}
