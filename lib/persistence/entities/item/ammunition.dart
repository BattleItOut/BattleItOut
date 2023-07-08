import 'package:battle_it_out/persistence/entities/item/item.dart';
import 'package:battle_it_out/persistence/entities/item/item_quality.dart';

class Ammunition extends Item {
  double rangeModifier;
  int rangeBonus;
  int damageBonus;

  Ammunition(
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
