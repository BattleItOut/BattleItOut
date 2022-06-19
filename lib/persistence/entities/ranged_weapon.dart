import 'package:battle_it_out/persistence/entities/ammunition.dart';
import 'package:battle_it_out/persistence/entities/attribute.dart';
import 'package:battle_it_out/persistence/entities/weapon.dart';

class RangedWeapon extends Weapon {
  int range;
  Attribute? rangeAttribute;
  bool useAmmo;
  Map<Ammunition, int> ammunition = {};

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
      qualities,
      Map<Ammunition, int> ammunition = const {}})
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

  void addAmmunition(Ammunition _ammunition, int quantity) {
    ammunition.update(_ammunition, (value) => value + quantity, ifAbsent: () => quantity);
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      "ID": id,
      "NAME": name,
      "WEAPON_RANGE": range,
      "RANGE_ATTRIBUTE": rangeAttribute?.id,
      "DAMAGE": damage,
      "DAMAGE_ATTRIBUTE": damageAttribute?.id,
      "SKILL": skill!.id,
      "USE_AMMO": useAmmo ? 1 : 0,
      "TWO-HANDED": twoHanded ? 1 : 0
    };
  }
}
