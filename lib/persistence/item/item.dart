import 'package:battle_it_out/persistence/item/item_quality.dart';
import 'package:battle_it_out/persistence/serializer.dart';
import 'package:battle_it_out/utils/database_provider.dart';
import 'package:flutter/foundation.dart' hide Factory;
import 'package:sqflite/sqlite_api.dart';

class Item {
  int id;
  String name;
  int count;

  int? cost;
  int encumbrance;
  String? availability;
  String? category;

  List<ItemQuality> qualities = [];

  Item({required this.id,
    required this.name,
    required this.encumbrance,
    this.cost,
    this.availability,
    this.category,
    this.count = 1,
    List<ItemQuality> qualities = const []}) {
    this.qualities.addAll(qualities);
  }

  bool isCommonItem() {
    return true;
  }

  void addQuality(ItemQuality quality) {
    qualities.add(quality);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Item && runtimeType == other.runtimeType && id == other.id && name == other.name &&
              count == other.count && cost == other.cost && encumbrance == other.encumbrance &&
              availability == other.availability && category == other.category && listEquals(qualities, other.qualities);

  @override
  int get hashCode =>
      id.hashCode ^ name.hashCode ^ count.hashCode ^ cost.hashCode ^ encumbrance.hashCode ^ availability
          .hashCode ^ category.hashCode ^ qualities.hashCode;
}

mixin SpecialItem {
  bool isCommonItem() {
    return false;
  }
}

class CommonItemFactory extends ItemFactory<Item>  {
  @override
  get tableName => "items";
  @override
  get qualitiesTableName => "items_qualities";
  @override
  // TODO: implement linkTableName
  get linkTableName => throw UnimplementedError();

  @override
  Future<Item> fromMap(Map<String, dynamic> map) async {
    return Item(
        id: map["ID"],
        name: map["NAME"],
        cost: map["COST"],
        encumbrance: map["ENCUMBRANCE"],
        availability: map["AVAILABILITY"],
        category: map["CATEGORY"]);
  }

  @override
  Future<Map<String, dynamic>> toMap(Item object, {optimised = true, database = false}) async {
    // TODO: implement toMap
    throw UnimplementedError();
  }

}

abstract class ItemFactory<T extends Item> extends Factory<T> {
  get qualitiesTableName;
  get linkTableName;

  Future<List<ItemQuality>> getQualities(int id) async {
    Database? database = await DatabaseProvider.instance.getDatabase();

    final List<Map<String, dynamic>> map = await database.query(linkTableName, where: "ITEM_ID = ?", whereArgs: [id]);
    List<ItemQuality> qualities = [];
    for (var entry in map) {
      ItemQuality itemQuality = await ItemQualityFactory().get(entry["QUALITY_ID"]);
      qualities.add(itemQuality);
    }
    return qualities;
  }

  @override
  Future<void> insert(T object) async {
    Map<String, dynamic> objectMap = await toMap(object, database: true);
    for (ItemQuality quality in object.qualities) {
      await insertMap({"ITEM_ID": object.id, "QUALITY_ID": quality.id, "VALUE": quality.value}, linkTableName);
    }
    await insertMap(objectMap);
  }
}