import 'package:battle_it_out/persistence/entities/ammunition.dart';
import 'package:battle_it_out/persistence/entities/attribute.dart';
import 'package:battle_it_out/persistence/entities/item_quality.dart';
import 'package:battle_it_out/persistence/entities/weapon.dart';

class RangedWeapon extends Weapon {
  int range;
  Attribute? rangeAttribute;
  bool useAmmo;
  List<Ammunition> ammunition = [];

  RangedWeapon(
      {required id,
      required name,
      required this.range,
      required this.useAmmo,
      required damage,
      required damageAttribute,
      this.rangeAttribute,
      twoHanded,
      skill,
      List<ItemQuality> qualities = const [],
      List<Ammunition> ammunition = const []})
      : super(id: id, name: name, qualities: qualities, damage: damage, twoHanded: twoHanded, damageAttribute: damageAttribute, skill: skill) {
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
          rangeAttribute == other.rangeAttribute;

  @override
  int get hashCode => super.hashCode ^ range.hashCode ^ rangeAttribute.hashCode;

  @override
  String toString() {
    return 'RangedWeapon{range: $range, rangeAttribute: $rangeAttribute, useAmmo: $useAmmo}';
  }
}
