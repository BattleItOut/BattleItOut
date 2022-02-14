import 'package:sqflite/sqflite.dart';

abstract class Entity {
  get tableName;

  fromMap(Map<String, dynamic> map);
  Map<String, dynamic> toMap();

  Future<dynamic> getOne(Database database, int id) async {
    final List<Map<String, dynamic>> map = await database.query(tableName, where: "ID = ?", whereArgs: [id]);
    return fromMap(map[0]);
  }

  Future<dynamic> getAll(Database database) async {
    final List<Map<String, dynamic>> map = await database.query(tableName);
    return List.generate(map.length, (i) {
      return fromMap(map[i]);
    });
  }

  Future<int> delete(Database database, int id) async {
    return await database.delete(tableName, where: "ID = ?", whereArgs: [id]);
  }

  Future<int> insert(Database database, Entity object) async {
    return await database.insert(tableName, object.toMap());
  }

  Future<int> update(Database database, int id, Entity object) async {
    return await database.update(tableName, object.toMap(), where: "ID = ?", whereArgs: [id]);
  }
}
