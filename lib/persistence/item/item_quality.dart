import 'package:battle_it_out/persistence/serializer.dart';

class ItemQuality {
  int id;
  String name;
  bool positive;
  String? equipment;
  String? description;
  int? value;

  ItemQuality(
      {required this.id,
      required this.name,
      required this.positive,
      required this.equipment,
      required this.description,
      this.value});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ItemQuality &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          positive == other.positive &&
          equipment == other.equipment &&
          description == other.description &&
          value == other.value;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      positive.hashCode ^
      equipment.hashCode ^
      description.hashCode ^
      value.hashCode;

  @override
  String toString() {
    if (value == null) {
      return "Quality (id=$id, name=$name)";
    } else {
      return "Quality (id=$id, name=$name $value)";
    }
  }
}

class ItemQualityFactory extends Factory<ItemQuality> {
  @override
  get tableName => 'item_qualities';

  @override
  Future<ItemQuality> fromMap(Map<String, dynamic> map) async {
    return ItemQuality(
        id: map['ID'] ?? await getNextId(),
        name: map['NAME'],
        positive: map['TYPE'] == 1,
        equipment: map['EQUIPMENT'],
        description: map['DESCRIPTION'],
        value: map["VALUE"]);
  }

  @override
  Future<Map<String, dynamic>> toMap(ItemQuality object, {optimised = true, database = false}) async {
    Map<String, dynamic> map = {
      "ID": object.id,
      "NAME": object.name,
      "POSITIVE": object.positive ? 1 : 0,
      "EQUIPMENT": object.equipment,
      "DESCRIPTION": object.description
    };
    if (!database) {
      map["VALUE"] = object.value;
      if (optimised) {
        map = await optimise(map);
      }
    }
    return map;
  }
}
