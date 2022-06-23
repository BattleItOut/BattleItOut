import 'package:battle_it_out/persistence/dao/dao.dart';

abstract class Serializer<T> {
  dynamic fromMap(Map<String, dynamic> _map);
  Map<String, dynamic> toMap(T object);
}

abstract class Factory<T> extends DAO<T> implements Serializer<T> {
  Future<T> create(Map<String, dynamic> map) async {
    Map<String, dynamic> newMap = {};
    if (map["ID"] != null) {
      newMap.addAll(await getMap(map["ID"]));
    }
    for (MapEntry<String, dynamic> entry in map.entries) {
      newMap.update(entry.key, (value) => entry.value, ifAbsent: () => entry.value);
    }
    return await fromMap(newMap);
  }
  dynamic get(int id) async {
    return fromMap(await getMap(id));
  }
  dynamic getWhere({where, List<Object>? whereArgs}) async {
    return fromMap(await getMapWhere(where: where, whereArgs: whereArgs));
  }
  Future<List<T>> getAll({String? where, List<Object>? whereArgs}) async {
    return [for (var entry in await getMapAll(where: where, whereArgs: whereArgs)) await fromMap(entry)];
  }
}