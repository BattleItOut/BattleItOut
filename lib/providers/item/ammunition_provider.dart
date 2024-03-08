import 'package:battle_it_out/persistence/item/ammunition.dart';
import 'package:battle_it_out/providers/item/abstract_item_provider.dart';

class AmmunitionRepository extends AbstractItemRepository<Ammunition> {
  @override
  get tableName => 'ammunition';
  @override
  get linkTableName => 'ammunition_qualities';

  @override
  Future<Ammunition> fromDatabase(Map<String, dynamic> map, [Map overrideMap = const {}]) async {
    return Ammunition(
        id: map["ID"],
        name: map["NAME"],
        rangeModifier: map["RANGE_MOD"],
        rangeBonus: map["RANGE_BONUS"],
        damageBonus: map["DAMAGE_BONUS"],
        amount: map["COUNT"] ?? 0,
        qualities: await getQualities(map["ID"]));
  }

  @override
  Future<Map<String, dynamic>> toDatabase(Ammunition object) async {
    return {
      "ID": object.id,
      "NAME": object.name,
      "RANGE_MOD": object.rangeModifier,
      "RANGE_BONUS": object.rangeBonus,
      "DAMAGE_BONUS": object.damageBonus,
      "COUNT": object.amount,
    };
  }

  // @override
  // Future<Map<String, dynamic>> toMap(Ammunition object, {optimised = true, database = false}) async {
  //   Map<String, dynamic> map = {
  //     "ID": object.id,
  //     "NAME": object.name,
  //     "RANGE_MOD": object.rangeModifier,
  //     "RANGE_BONUS": object.rangeBonus,
  //     "DAMAGE_BONUS": object.damageBonus,
  //     "COUNT": object.count,
  //   };
  //   if (!database) {
  //     map["QUALITIES"] = [for (ItemQuality quality in object.qualities) await ItemQualityRepository().toDatabase(quality)];
  //     if (optimised) {
  //       map = await optimise(map);
  //     }
  //   }
  //   return map;
  // }
}
