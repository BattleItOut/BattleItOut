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
