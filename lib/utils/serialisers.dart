import 'package:battle_it_out/utils/dao.dart';
import 'package:battle_it_out/utils/db_object.dart';
import 'package:flutter/foundation.dart';

abstract mixin class DBSerializer<T> implements DAO {
  Future<T> fromDatabase(Map<String, dynamic> map);

  Future<Map<String, Object?>> toDatabase(T object);
}

abstract mixin class JSONSerializer<T extends DBObject> implements DBSerializer<T> {
  get defaultValues => {};

  Future<Map<String, Object?>> toMap(T object, {optimised = true}) {
    return toDatabase(object);
  }

  Future<T> fromMap(Map<String, dynamic> map) {
    return fromDatabase(map);
  }

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
