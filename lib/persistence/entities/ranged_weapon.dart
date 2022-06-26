import 'package:battle_it_out/persistence/entities/attribute.dart';
import 'package:battle_it_out/persistence/entities/item_quality.dart';
import 'package:battle_it_out/persistence/entities/weapon.dart';

class RangedWeapon extends Weapon {
  int range;
  Attribute? rangeAttribute;

  int ammunition;

  RangedWeapon(
      {required id,
      required name,
      required this.range,
      this.rangeAttribute,
      required damage,
      required damageAttribute,
      skill,
      List<ItemQuality> qualities = const [],
      this.ammunition = 0})
      : super(id: id, name: name, qualities: qualities, damage: damage, damageAttribute: damageAttribute, skill: skill);

  int getRange() {
    return rangeAttribute?.getTotalBonus() ?? 1 * range;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is RangedWeapon &&
          runtimeType == other.runtimeType &&
          range == other.range &&
          rangeAttribute == other.rangeAttribute &&
          ammunition == other.ammunition;

  @override
  int get hashCode => super.hashCode ^ range.hashCode ^ rangeAttribute.hashCode ^ ammunition.hashCode;
}
