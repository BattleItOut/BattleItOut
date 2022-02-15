import 'package:battle_it_out/persistence/dao/dao.dart';
import 'package:battle_it_out/persistence/entities/item_quality.dart';
import 'package:battle_it_out/persistence/wfrp_database.dart';

class ItemQualityDAO extends DAO<ItemQuality> {
  @override
  get tableName => 'item_qualities';

  @override
  ItemQuality fromMap(Map<String, dynamic> map, WFRPDatabase database) {
    return ItemQuality(
        id: map['ID'],
        name: map['NAME'],
        nameEng: map['NAME_ENG'],
        type: map['TYPE'],
        equipment: map['EQUIPMENT'],
        description: map['DESCR'],
        value: map["VALUE"]);
  }
}
