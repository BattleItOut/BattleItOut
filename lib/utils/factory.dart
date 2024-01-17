import 'package:battle_it_out/utils/dao.dart';
import 'package:battle_it_out/utils/db_object.dart';
import 'package:flutter/foundation.dart';

mixin DBSerializer<T> {
  Future<T> fromDatabase(Map<String, dynamic> map);

  Future<Map<String, Object?>> toDatabase(T object);
}

mixin JSONSerializer<T extends DBObject> implements DAO {
  get defaultValues => {};

  Future<Map<String, Object?>> toMap(T object, {optimised = true});

  Future<T> fromMap(Map<String, dynamic> map);

  Future<T> create(Map<String, dynamic> map) async {
    Map<String, Object?> newMap = {};
    if (map["ID"] != null) {
      newMap.addAll(await getMapWhere(where: "ID = ?", whereArgs: [map["ID"]]));
    }
    defaultValues.forEach((key, value) => newMap.putIfAbsent(key, () => value));
    map.forEach((key, newValue) => newMap.update(key, (oldValue) => newValue, ifAbsent: () => newValue));
    return fromMap(newMap);
  }

  Future<Map<String, dynamic>> optimise(Map<String, dynamic> map) async {
    map.removeWhere((key, value) => value == null || defaultValues[key] == value);
    map.removeWhere((key, value) => value is List && value.isEmpty);
    if (map["ID"] != null) {
      Map<String, dynamic> defaultMap = await getMapWhere(where: "ID = ?", whereArgs: [map["ID"]]);
      map.removeWhere((key, value) =>
          key != "ID" &&
          (value is List && listEquals(value, defaultMap[key]) || value is! List && value == defaultMap[key]));
    }
    return map;
  }
}

abstract class Factory<T extends DBObject> extends DAO with JSONSerializer<T>, DBSerializer<T> {
  @override
  Future<Map<String, Object?>> toMap(T object, {optimised = true}) {
    return toDatabase(object);
  }

  @override
  Future<T> fromMap(Map<String, dynamic> map) {
    return fromDatabase(map);
  }

  Future<T> update(T object) async {
    object.id = await insertMap(await toDatabase(object));
    return object;
  }

  Future<T?> getNullable(int? id) async {
    if (id == null) {
      return null;
    } else {
      return get(id);
    }
  }

  Future<T> get(int id) async {
    return fromDatabase({
      for (var entry in (await getMapWhere(where: "ID = ?", whereArgs: [id])).entries) entry.key: entry.value
    });
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
