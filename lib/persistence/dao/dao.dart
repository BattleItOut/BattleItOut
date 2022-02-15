import 'package:battle_it_out/persistence/entities/dto.dart';
import 'package:battle_it_out/persistence/wfrp_database.dart';
import 'package:sqflite/sqflite.dart';

abstract class DAO<T extends DTO> {
  get tableName;

  dynamic fromMap(Map<String, dynamic> map, WFRPDatabase database);

  Future<T> get(WFRPDatabase database, int id) async {
    final List<Map<String, dynamic>> map = await database.database!.query(tableName, where: "ID = ?", whereArgs: [id]);
    return await fromMap(map[0], database);
  }

  Future<List<T>> getAll({required WFRPDatabase database, String? where, List<Object?>? whereArgs}) async {
    final List<Map<String, dynamic>> map =
        await database.database!.query(tableName, where: where, whereArgs: whereArgs);

    List<T> outputList = [];
    for (var entry in map) {
      outputList.add(await fromMap(entry, database));
    }
    return outputList;
  }

  Future<int> save(Database database, T t) async {
    return await database.insert(tableName, t.toMap());
  }

  Future<int> update(Database database, int id, T t) async {
    return await database.update(tableName, t.toMap(), where: "ID = ?", whereArgs: [id]);
  }

  Future<int> delete(Database database, int id) async {
    return await database.delete(tableName, where: "ID = ?", whereArgs: [id]);
  }
}
