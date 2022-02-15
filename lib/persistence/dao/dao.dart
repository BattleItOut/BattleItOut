import 'package:battle_it_out/persistence/entities/dto.dart';
import 'package:battle_it_out/persistence/database_provider.dart';
import 'package:sqflite/sqflite.dart';

abstract class DAO<T extends DTO> {
  get tableName;

  dynamic fromMap(Map<String, dynamic> map);

  Future<T> get(int id) async {
    Database? database = await DatabaseProvider.instance.getDatabase();

    final List<Map<String, dynamic>> map = await database!.query(tableName, where: "ID = ?", whereArgs: [id]);
    return await fromMap(map[0]);
  }

  Future<List<T>> getAll({String? where, List<Object?>? whereArgs}) async {
    Database? database = await DatabaseProvider.instance.getDatabase();

    final List<Map<String, dynamic>> map = await database!.query(tableName, where: where, whereArgs: whereArgs);

    List<T> outputList = [];
    for (var entry in map) {
      outputList.add(await fromMap(entry));
    }
    return outputList;
  }

  Future<int> save(T t) async {
    Database? database = await DatabaseProvider.instance.getDatabase();

    return await database!.insert(tableName, t.toMap());
  }

  Future<int> update(int id, T t) async {
    Database? database = await DatabaseProvider.instance.getDatabase();

    return await database!.update(tableName, t.toMap(), where: "ID = ?", whereArgs: [id]);
  }

  Future<int> delete(int id) async {
    Database? database = await DatabaseProvider.instance.getDatabase();

    return await database!.delete(tableName, where: "ID = ?", whereArgs: [id]);
  }
}
