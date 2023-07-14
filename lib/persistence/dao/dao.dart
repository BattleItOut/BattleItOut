import 'package:battle_it_out/persistence/database_provider.dart';
import 'package:sqflite/sqflite.dart';

abstract class DAO {
  get tableName;

  Future<Map<String, dynamic>> getMap(int id) async {
    return getMapWhere(where: "ID = ?", whereArgs: [id]);
  }

  Future<Map<String, dynamic>> getMapWhere({where, List<Object>? whereArgs}) async {
    Database? database = await DatabaseProvider.instance.getDatabase();

    List<Map<String, dynamic>> list = (await database.query(tableName, where: where, whereArgs: whereArgs));
    return list.isNotEmpty ? list[0] : {};
  }

  Future<Map<String, dynamic>> getNextIdMap() async {
    Database? database = await DatabaseProvider.instance.getDatabase();

    return (await database.rawQuery("SELECT MAX(ID)+1 AS NEXT_ID FROM $tableName"))[0];
  }

  Future<List<Map<String, dynamic>>> getMapAll({String? where, List<Object>? whereArgs}) async {
    Database? database = await DatabaseProvider.instance.getDatabase();

    return await database.query(tableName, where: where, whereArgs: whereArgs);
  }

  Future<void> insertMap(Map<String, Object?> map, [String? tableName]) async {
    Database? database = await DatabaseProvider.instance.getDatabase();

    database.insert(tableName ?? this.tableName, map);
  }

  Future<int> set(int id, map) async {
    Database? database = await DatabaseProvider.instance.getDatabase();

    return await database.update(tableName, map, where: "ID = ?", whereArgs: [id]);
  }

  Future<int> delete(int id) async {
    Database? database = await DatabaseProvider.instance.getDatabase();

    return await database.delete(tableName, where: "ID = ?", whereArgs: [id]);
  }
}
