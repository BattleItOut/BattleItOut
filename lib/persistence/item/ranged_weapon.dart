import 'package:battle_it_out/persistence/attribute.dart';
import 'package:battle_it_out/persistence/item/ammunition.dart';
import 'package:battle_it_out/persistence/item/weapon.dart';

class RangedWeapon extends Weapon {
  int range;
  Attribute? rangeAttribute;
  bool useAmmo;
  List<Ammunition> ammunition = [];

  RangedWeapon(
      {super.id,
      required super.name,
      required this.range,
      required this.useAmmo,
      required super.damage,
      required super.damageAttribute,
      this.rangeAttribute,
      super.twoHanded,
      super.skill,
      super.qualities = const [],
      List<Ammunition> ammunition = const []})
      : super(category: "RANGED_WEAPONS") {
    this.ammunition.addAll(ammunition);
  }

  int getRange([Ammunition? ammo]) {
    int value = rangeAttribute?.getTotalBonus() ?? 1 * range;
    if (ammo != null) {
      value = (value * ammo.rangeModifier).toInt() + ammo.rangeBonus;
    }
    return value;
  }

  @override
  int getTotalDamage([Ammunition? ammo]) {
    int value = super.getTotalDamage();
    if (ammo != null) {
      value + ammo.damageBonus;
    }
    return value;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is RangedWeapon &&
          runtimeType == other.runtimeType &&
          range == other.range &&
          rangeAttribute == other.rangeAttribute &&
          useAmmo == other.useAmmo;

  @override
  int get hashCode => super.hashCode ^ range.hashCode ^ rangeAttribute.hashCode ^ useAmmo.hashCode;

  @override
  String toString() {
    return 'RangedWeapon{range: $range, rangeAttribute: $rangeAttribute, useAmmo: $useAmmo, ammunition: $ammunition}';
  }
}
