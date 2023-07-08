import 'package:battle_it_out/persistence/dao/dao.dart';
import 'package:flutter/foundation.dart';

abstract class Serializer<T> {
  get defaultValues;

  dynamic fromMap(Map<String, dynamic> _map);
  dynamic toMap(T object, [optimised = true]);
}

abstract class Factory<T> extends DAO<T> implements Serializer<T> {
  @override
  get defaultValues => {};

  Future<T> create(Map<String, dynamic> map) async {
    Map<String, dynamic> newMap = {};
    if (map["ID"] != null) {
      newMap.addAll(await getMap(map["ID"]));
    }
    for (MapEntry<String, dynamic> entry in map.entries) {
      newMap.update(entry.key, (value) => entry.value,
          ifAbsent: () => entry.value);
    }
    return await fromMap(newMap);
  }

  dynamic get(int id) async {
    return fromMap(
        {for (var entry in (await getMap(id)).entries) entry.key: entry.value});
  }

  dynamic getWhere({where, List<Object>? whereArgs}) async {
    return fromMap(await getMapWhere(where: where, whereArgs: whereArgs));
  }

  Future<List<T>> getAll({String? where, List<Object>? whereArgs}) async {
    return [
      for (var map in await getMapAll(where: where, whereArgs: whereArgs))
        await fromMap({for (var entry in map.entries) entry.key: entry.value})
    ];
  }

  Future<Map<String, dynamic>> optimise(Map<String, dynamic> map) async {
    map.removeWhere(
        (key, value) => value == null || defaultValues[key] == value);
    if (map["ID"] != null) {
      Map<String, dynamic> defaultMap =
          await toMap(await get(map["ID"]), false);
      map.removeWhere((key, value) =>
          key != "ID" &&
          (value is List && listEquals(value, defaultMap[key]) ||
              value is! List && value == defaultMap[key]));
    }
    return map;
  }
}
