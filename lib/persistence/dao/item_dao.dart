import 'package:battle_it_out/persistence/dao/item_quality_dao.dart';
import 'package:battle_it_out/persistence/dao/serializer.dart';
import 'package:battle_it_out/persistence/database_provider.dart';
import 'package:battle_it_out/persistence/entities/item.dart';
import 'package:battle_it_out/persistence/entities/item_quality.dart';
import 'package:sqflite/sqlite_api.dart';

abstract class ItemFactory<T extends Item> extends Factory<T> {
  get qualitiesTableName;

  Future<List<ItemQuality>> getQualities(int id) async {
    Database? database = await DatabaseProvider.instance.getDatabase();

    final List<Map<String, dynamic>> map =
        await database.query(qualitiesTableName, where: "ITEM_ID = ?", whereArgs: [id]);
    List<ItemQuality> qualities = [];
    for (var entry in map) {
      ItemQuality itemQuality = await ItemQualityFactory().get(entry["QUALITY_ID"]);
      itemQuality.mapNeeded = false;
      qualities.add(itemQuality);
    }
    return qualities;
  }
}