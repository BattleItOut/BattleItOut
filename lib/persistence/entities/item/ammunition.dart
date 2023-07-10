import 'package:battle_it_out/persistence/entities/item/item.dart';
import 'package:battle_it_out/persistence/entities/item/item_quality.dart';

class Ammunition extends Item {
  double rangeModifier;
  int rangeBonus;
  int damageBonus;

  Ammunition(
      {this.rangeModifier = 1,
      this.rangeBonus = 0,
      this.damageBonus = 0,
      String? id,
      int? databaseId,
      required String name,
      int count = 1,
      int encumbrance = 0,
      String? category = "AMMUNITION",
      List<ItemQuality> qualities = const []})
      : super(
            id: id,
            databaseId: databaseId,
            name: name,
            count: count,
            encumbrance: encumbrance,
            category: category,
            qualities: qualities);

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
