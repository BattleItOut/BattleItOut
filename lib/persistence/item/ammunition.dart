import 'package:battle_it_out/persistence/item/item.dart';

class Ammunition extends Item {
  double rangeModifier;
  int rangeBonus;
  int damageBonus;

  Ammunition(
      {super.id,
      required super.name,
      super.amount = 1,
      super.encumbrance = 0,
      this.rangeModifier = 1,
      this.rangeBonus = 0,
      this.damageBonus = 0,
      itemCategory,
      super.qualities})
      : super(category: "AMMUNITION");

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
    return 'Ammunition{rangeModifier: $rangeModifier, rangeBonus: $rangeBonus, damageBonus: $damageBonus, count: $amount}';
  }
}

class AmmunitionFactory extends ItemFactory<Ammunition> {
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
        itemCategory: map["ITEM_CATEGORY"],
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
  //     map["QUALITIES"] = [for (ItemQuality quality in object.qualities) await ItemQualityFactory().toDatabase(quality)];
  //     if (optimised) {
  //       map = await optimise(map);
  //     }
  //   }
  //   return map;
  // }
}
