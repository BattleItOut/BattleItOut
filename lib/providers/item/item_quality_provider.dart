import 'package:battle_it_out/persistence/item/item_quality.dart';
import 'package:battle_it_out/utils/factory.dart';

class ItemQualityRepository extends Repository<ItemQuality> {
  @override
  get tableName => 'item_qualities';

  @override
  Future<ItemQuality> fromDatabase(Map<String, dynamic> map) async {
    return ItemQuality(
        id: map['ID'],
        name: map['NAME'],
        positive: map['TYPE'] == 1,
        equipment: map['EQUIPMENT'],
        description: map['DESCRIPTION'],
        value: map["VALUE"]);
  }

  @override
  Future<Map<String, dynamic>> toDatabase(ItemQuality object) async {
    return {
      "ID": object.id,
      "NAME": object.name,
      "POSITIVE": object.positive ? 1 : 0,
      "EQUIPMENT": object.equipment,
      "DESCRIPTION": object.description
    };
  }
}
