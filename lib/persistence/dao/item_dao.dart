import 'package:battle_it_out/persistence/dao/dao.dart';
import 'package:battle_it_out/persistence/dao/item_quality_dao.dart';
import 'package:battle_it_out/persistence/database_provider.dart';
import 'package:battle_it_out/persistence/entities/item.dart';
import 'package:battle_it_out/persistence/entities/item_quality.dart';
import 'package:sqflite/sqlite_api.dart';

abstract class ItemDAO<T extends Item> extends DAO<T> {
  get qualitiesTableName;

  Future<List<ItemQuality>> getQualities(int id) async {
    Database? database = await DatabaseProvider.instance.getDatabase();

    final List<Map<String, dynamic>> map =
        await database.query(qualitiesTableName, where: "ITEM_ID = ?", whereArgs: [id]);
    return [for (var entry in map) await ItemQualityDAO().get(entry["QUALITY_ID"])];
  }
}
