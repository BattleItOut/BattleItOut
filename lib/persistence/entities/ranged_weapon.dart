import 'package:battle_it_out/persistence/entities/ammunition.dart';
import 'package:battle_it_out/persistence/entities/attribute.dart';
import 'package:battle_it_out/persistence/entities/weapon.dart';

class RangedWeapon extends Weapon {
  int range;
  Attribute? rangeAttribute;
  Map<Ammunition, int> ammunition = {};

  RangedWeapon(
      {required id,
      required name,
      required this.range,
      this.rangeAttribute,
      required damage,
      required damageAttribute,
      skill,
      qualities,
      Map<Ammunition, int> ammunition = const {}})
      : super(id: id, name: name, qualities: qualities, damage: damage, damageAttribute: damageAttribute, skill: skill) {
    this.ammunition.addAll(ammunition);
  }

  int getRange() {
    return rangeAttribute?.getTotalBonus() ?? 1 * range;
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
      "SKILL": skill!.id
    };
  }
}
