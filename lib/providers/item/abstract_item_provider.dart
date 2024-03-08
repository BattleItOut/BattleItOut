import 'package:battle_it_out/persistence/item/item.dart';
import 'package:battle_it_out/persistence/item/item_quality.dart';
import 'package:battle_it_out/providers/item/item_quality_provider.dart';
import 'package:battle_it_out/utils/factory.dart';

abstract class AbstractItemRepository<T extends Item> extends Repository<T> {
  @override
  get tableName => "items";
  get qualitiesTableName => "items_qualities";
  get linkTableName;

  Future<List<ItemQuality>> getQualities(int id) async {
    final List<Map<String, dynamic>> map = await database.query(linkTableName, where: "ITEM_ID = ?", whereArgs: [id]);
    List<ItemQuality> qualities = [];
    for (var entry in map) {
      qualities.add((await ItemQualityRepository().get(entry["QUALITY_ID"]))!);
    }
    return qualities;
  }

  @override
  Future<T> update(T object) async {
    object = await super.update(object);
    for (ItemQuality quality in object.qualities) {
      await ItemQualityRepository().update(quality);
      await updateMap({"ITEM_ID": object.id, "QUALITY_ID": quality.id, "VALUE": quality.value}, linkTableName);
    }
    return object;
  }
}
