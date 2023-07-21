import 'package:battle_it_out/persistence/dao.dart';
import 'package:flutter/foundation.dart';

abstract class Serializer<T> {
  get defaultValues;

  Future<T> fromMap(Map<String, dynamic> map);

  Future<Map<String, Object?>> toMap(T object, {optimised = true, database = false});
}

abstract class Factory<T> extends DAO implements Serializer<T> {
  @override
  get defaultValues => {};

  Future<T> create(Map<String, dynamic> map) async {
    Map<String, Object?> newMap = {};
    if (map["ID"] != null) {
      newMap.addAll(await getMap(map["ID"]));
    }
    defaultValues.forEach((key, value) => newMap.putIfAbsent(key, () => value));
    map.forEach((key, newValue) => newMap.update(key, (oldValue) => newValue, ifAbsent: () => newValue));

    T object = await fromMap(newMap);
    if (map["ID"] == null) {
      await insert(object);
    }
    return object;
  }

  Future<void> insert(T object) async {
    insertMap(await toMap(object, optimised: false, database: true));
  }

  Future<T> get(int id) async {
    return fromMap({for (var entry in (await getMap(id)).entries) entry.key: entry.value});
  }

  Future<T?> getWhere({where, List<Object>? whereArgs}) async {
    Map<String, dynamic> map = await getMapWhere(where: where, whereArgs: whereArgs);
    return map.isNotEmpty ? fromMap(map) : null;
  }

  Future<List<T>> getAll({String? where, List<Object>? whereArgs}) async {
    return [
      for (var map in await getMapAll(where: where, whereArgs: whereArgs))
        await fromMap({for (var entry in map.entries) entry.key: entry.value})
    ];
  }

  Future<Map<String, dynamic>> optimise(Map<String, dynamic> map) async {
    map.removeWhere((key, value) => value == null || defaultValues[key] == value);
    map.removeWhere((key, value) => value is List && value.isEmpty);
    if (map["ID"] != null) {
      Map<String, dynamic> defaultMap = await toMap(await get(map["ID"]), optimised: false);
      map.removeWhere((key, value) =>
          key != "ID" &&
          (value is List && listEquals(value, defaultMap[key]) || value is! List && value == defaultMap[key]));
    }
    return map;
  }
}
