import 'package:battle_it_out/persistence/dao/item/item_dao.dart';
import 'package:battle_it_out/persistence/dao/item/item_quality_dao.dart';
import 'package:battle_it_out/persistence/entities/item/ammunition.dart';
import 'package:battle_it_out/persistence/entities/item/item_quality.dart';

class AmmunitionFactory extends ItemFactory<Ammunition> {
  @override
  get tableName => 'weapons_ranged_ammunition';
  @override
  get qualitiesTableName => 'item_qualities';
  @override
  get linkTableName => 'weapons_ranged_ammunition_qualities';

  @override
  Future<Ammunition> fromMap(Map<String, dynamic> map, [Map overrideMap = const {}]) async {
    return Ammunition(
        id: map["ID"],
        name: map["NAME"],
        rangeModifier: map["RANGE_MOD"],
        rangeBonus: map["RANGE_BONUS"],
        damageBonus: map["DAMAGE_BONUS"],
        count: map["COUNT"] ?? 0,
        itemCategory: map["ITEM_CATEGORY"],
        qualities: await getQualities(map["ID"]));
  }

  @override
  Future<Map<String, dynamic>> toMap(Ammunition object, {optimised = true, database = false}) async {
    Map<String, dynamic> map = {
      "ID": object.id,
      "NAME": object.name,
      "RANGE_MOD": object.rangeModifier,
      "RANGE_BONUS": object.rangeBonus,
      "DAMAGE_BONUS": object.damageBonus,
      "COUNT": object.count,
    };
    if (!database) {
      if (object.qualities.isNotEmpty) {
        map["QUALITIES"] = [for (ItemQuality quality in object.qualities) await ItemQualityFactory().toMap(quality)];
      }
      if (optimised) {
        map = await optimise(map);
      }
    }
    return map;
  }
}
