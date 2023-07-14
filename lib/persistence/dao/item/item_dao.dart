import 'package:battle_it_out/persistence/dao/item/item_quality_dao.dart';
import 'package:battle_it_out/persistence/dao/serializer.dart';
import 'package:battle_it_out/persistence/database_provider.dart';
import 'package:battle_it_out/persistence/entities/item/item.dart';
import 'package:battle_it_out/persistence/entities/item/item_quality.dart';
import 'package:sqflite/sqlite_api.dart';

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
      itemQuality.mapNeeded = false;
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