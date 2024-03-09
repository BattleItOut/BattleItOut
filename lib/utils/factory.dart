import 'package:battle_it_out/providers/database_provider.dart';
import 'package:battle_it_out/utils/dao.dart';
import 'package:battle_it_out/utils/db_object.dart';
import 'package:battle_it_out/utils/serialisers.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

abstract class Repository<T extends DBObject> with DAO, JSONSerializer<T>, ChangeNotifier {
  List<T>? _items;
  bool ready = false;
  List<T> get items => _items!;

  Future<void> init() async {
    if (ready) return;
    await GetIt.instance.get<DatabaseRepository>().init();
    await refresh();
  }

  Future<void> refresh() async {
    _items = await getAll();
    ready = true;
    super.notifyListeners();
  }

  Future<T> update(T object) async {
    await init();
    object.id = await updateMap(await toDatabase(object));
    await refresh();
    return object;
  }

  Future<int> delete(T object) async {
    await init();
    int id = await super.deleteMap(object.id!);
    await refresh();
    return id;
  }

  Future<T?> get(int? id) async {
    await init();
    return id == null ? null : items.firstWhereOrNull((T item) => item.id == id);
  }

  Future<List<T>> getAll({String? where, List<Object>? whereArgs}) async {
    List<Map<String, Object?>> list = await getMapAll(where: where, whereArgs: whereArgs);
    return [
      for (Map<String, Object?> map in list) await fromDatabase({for (var entry in map.entries) entry.key: entry.value})
    ];
  }

  @override
  Future<T> create(Map<String, dynamic> map) async {
    await init();
    return super.create(map);
  }
}
