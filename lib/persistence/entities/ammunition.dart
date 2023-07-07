import 'package:battle_it_out/persistence/entities/item.dart';

class Ammunition extends Item {
  double rangeModifier;
  int rangeBonus;
  int damageBonus;
  int count;

  Ammunition({required int id, required String name, qualities, this.count = 1,
    this.rangeModifier = 1, this.rangeBonus = 0, this.damageBonus = 0})
      : super(id: id, name: name, qualities: qualities);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is Ammunition &&
          runtimeType == other.runtimeType &&
          rangeModifier == other.rangeModifier &&
          rangeBonus == other.rangeBonus &&
          damageBonus == other.damageBonus &&
          count == other.count;

  @override
  int get hashCode =>
      super.hashCode ^
      rangeModifier.hashCode ^
      rangeBonus.hashCode ^
      damageBonus.hashCode ^
      count.hashCode;

  @override
  String toString() {
    return 'Ammunition{rangeModifier: $rangeModifier, rangeBonus: $rangeBonus, damageBonus: $damageBonus, count: $count}';
  }
}