import 'package:battle_it_out/persistence/dao/item_dao.dart';
import 'package:battle_it_out/persistence/entities/ammunition.dart';

class AmmunitionDAO extends ItemDAO<Ammunition> {
  @override
  get tableName => 'weapons_ranged_ammunition';

  @override
  get qualitiesTableName => 'weapons_ranged_ammunition_qualities';

  @override
  Future<Ammunition> fromMap(Map<String, dynamic> map, [Map overrideMap = const {}]) async {
    return Ammunition(
        id: map["ID"],
        name: map["NAME"],
        rangeModifier: map["RANGE_MOD"],
        rangeBonus: map["RANGE_BONUS"],
        damageBonus: map["DAMAGE_BONUS"],
        qualities: await getQualities(map["ID"]));
  }
}
