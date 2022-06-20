import 'package:battle_it_out/persistence/dao/dao.dart';
import 'package:battle_it_out/persistence/dao/item_quality_dao.dart';
import 'package:battle_it_out/persistence/database_provider.dart';
import 'package:battle_it_out/persistence/entities/item.dart';
import 'package:battle_it_out/persistence/entities/item_quality.dart';
import 'package:sqflite/sqlite_api.dart';

class ItemDAO<T extends Item> extends DAO<T> {
  @override
  get tableName => "items";
  get qualitiesTableName => "items_qualities";

  Future<List<ItemQuality>> getQualities(int id) async {
    Database? database = await DatabaseProvider.instance.getDatabase();

    final List<Map<String, dynamic>> map =
        await database.query(qualitiesTableName, where: "ITEM_ID = ?", whereArgs: [id]);
    return [for (var entry in map) await ItemQualityDAO().get(entry["QUALITY_ID"])];
  }

  @override
  fromMap(Map<String, dynamic> map, [Map overrideMap = const {}]) {
    return Item(
        id: map["ID"],
        name: map["NAME"],
        cost: map["COST"],
        encumbrance: map["ENCUMBRANCE"],
        availability: map["AVAILABILITY"],
        category: map["CATEGORY"]
    );
  }
}
