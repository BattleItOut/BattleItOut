import 'package:battle_it_out/persistence/dao/dao.dart';
import 'package:battle_it_out/persistence/entities/item_quality.dart';

class ItemQualityDAO extends DAO<ItemQuality> {
  @override
  get tableName => 'item_qualities';

  @override
  ItemQuality fromMap(Map<String, dynamic> map, [Map overrideMap = const {}]) {
    return ItemQuality(
        id: map['ID'],
        name: map['NAME'],
        positive: map['TYPE'] == 1,
        equipment: map['EQUIPMENT'],
        description: map['DESCRIPTION'],
        value: map["VALUE"]);
  }
}
