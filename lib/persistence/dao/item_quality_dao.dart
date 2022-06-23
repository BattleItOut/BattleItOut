import 'package:battle_it_out/persistence/dao/serializer.dart';
import 'package:battle_it_out/persistence/entities/item_quality.dart';

class ItemQualityFactory extends Factory<ItemQuality> {
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

  @override
  Map<String, dynamic> toMap(ItemQuality object) {
    return {
      "ID": object.id,
      "NAME": object.name,
      "POSITIVE": object.positive ? 1 : 0,
      "EQUIPMENT": object.equipment,
      "DESCRIPTION": object.description,
      "VALUE": object.value
    };
  }
}
