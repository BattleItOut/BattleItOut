import 'package:battle_it_out/persistence/item/item.dart';
import 'package:battle_it_out/persistence/item/item_quality.dart';

class Ammunition extends Item {
  double rangeModifier;
  int rangeBonus;
  int damageBonus;

  Ammunition._(
      {required int id,
      required String name,
      this.rangeModifier = 1,
      this.rangeBonus = 0,
      this.damageBonus = 0,
      itemCategory,
      count = 1,
      encumbrance = 0,
      List<ItemQuality> qualities = const []})
      : super(id: id, name: name, count: count, encumbrance: encumbrance, category: itemCategory, qualities: qualities);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is Ammunition &&
          runtimeType == other.runtimeType &&
          rangeModifier == other.rangeModifier &&
          rangeBonus == other.rangeBonus &&
          damageBonus == other.damageBonus;

  @override
  int get hashCode => super.hashCode ^ rangeModifier.hashCode ^ rangeBonus.hashCode ^ damageBonus.hashCode;

  @override
  String toString() {
    return 'Ammunition{rangeModifier: $rangeModifier, rangeBonus: $rangeBonus, damageBonus: $damageBonus, count: $count}';
  }
}

class AmmunitionFactory extends ItemFactory<Ammunition> {
  @override
  get tableName => 'weapons_ranged_ammunition';
  @override
  get qualitiesTableName => 'item_qualities';
  @override
  get linkTableName => 'weapons_ranged_ammunition_qualities';

  @override
  Future<Ammunition> fromMap(Map<String, dynamic> map, [Map overrideMap = const {}]) async {
    return Ammunition._(
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
      map["QUALITIES"] = [for (ItemQuality quality in object.qualities) await ItemQualityFactory().toMap(quality)];
      if (optimised) {
        map = await optimise(map);
      }
    }
    return map;
  }
}
