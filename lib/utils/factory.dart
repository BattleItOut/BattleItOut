import 'package:battle_it_out/providers/database_provider.dart';
import 'package:battle_it_out/utils/dao.dart';
import 'package:battle_it_out/utils/db_object.dart';
import 'package:battle_it_out/utils/serialisers.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:logging/logging.dart';

abstract class Factory<T extends DBObject> with DAO, JSONSerializer<T>, ChangeNotifier {
  Logger log = Logger("Factory");
  List<T>? _items;
  List<T> get items => _items!;

  Future<void> init() async {
    await GetIt.instance.get<DatabaseProvider>().init();
    if (_items != null) return;
    await refresh();
  }

  Future<void> refresh() async {
    _items = await getAll();
    super.notifyListeners();
  }

  Future<T> update(T object) async {
    object.id = await updateMap(await toDatabase(object));
    await refresh();
    return object;
  }

  Future<int> delete(T object) async {
    int id = await super.deleteMap(object.id!);
    await refresh();
    return id;
  }

  Future<T?> getNullable(int? id) async {
    if (id == null) {
      return null;
    } else {
      return get(id);
    }
  }

  Future<T?> get(int id) async {
    T? item = items.firstWhereOrNull((T item) => item.id == id);
    return item;
  }

  Future<T?> getWhere({String? where, List<Object>? whereArgs}) async {
    Map<String, dynamic> map = await getMapWhere(where: where, whereArgs: whereArgs);
    return map.isNotEmpty ? fromDatabase(map) : null;
  }

  Future<List<T>> getAll({String? where, List<Object>? whereArgs}) async {
    return [
      for (var map in await getMapAll(where: where, whereArgs: whereArgs))
        await fromDatabase({for (var entry in map.entries) entry.key: entry.value})
    ];
  }
}
