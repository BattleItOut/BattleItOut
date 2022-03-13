import 'package:battle_it_out/persistence/entities/dto.dart';
import 'package:battle_it_out/persistence/database_provider.dart';
import 'package:sqflite/sqflite.dart';

abstract class DAO<T extends DTO> {
  get tableName;

  dynamic fromMap(Map<String, dynamic> map, [Map overrideMap = const {}]);

  Future<T> get(int id, [Map overrideMap = const {}]) async {
    return getWhere(where: "ID = ?", whereArgs: [id], overrideMap: overrideMap);
  }

  Future<T> getWhere({where, List<Object>? whereArgs, Map overrideMap = const {}}) async {
    Database? database = await DatabaseProvider.instance.getDatabase();

    final List<Map<String, dynamic>> map = await database!.query(tableName, where: where, whereArgs: whereArgs);
    return await fromMap(map[0], overrideMap);
  }

  Future<List<T>> getAll({String? where, List<Object>? whereArgs}) async {
    Database? database = await DatabaseProvider.instance.getDatabase();

    final List<Map<String, dynamic>> map = await database!.query(tableName, where: where, whereArgs: whereArgs);
    return [for (var entry in map) await fromMap(entry)];
  }

  Future<int> put(T t) async {
    Database? database = await DatabaseProvider.instance.getDatabase();

    return await database!.insert(tableName, t.toMap());
  }

  Future<int> set(int id, T t) async {
    Database? database = await DatabaseProvider.instance.getDatabase();

    return await database!.update(tableName, t.toMap(), where: "ID = ?", whereArgs: [id]);
  }

  Future<int> delete(int id) async {
    Database? database = await DatabaseProvider.instance.getDatabase();

    return await database!.delete(tableName, where: "ID = ?", whereArgs: [id]);
  }
}
