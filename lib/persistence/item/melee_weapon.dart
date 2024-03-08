import 'package:battle_it_out/persistence/item/weapon.dart';
import 'package:battle_it_out/persistence/item/weapon_length.dart';

class MeleeWeapon extends Weapon {
  WeaponLength length;

  MeleeWeapon(
      {required super.name,
      required this.length,
      required super.damage,
      required super.twoHanded,
      super.id,
      super.damageAttribute,
      super.skill,
      super.qualities = const []})
      : super(category: "MELEE_WEAPONS");

  int getTotalSkillValue() {
    return skill!.getTotalValue();
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other && other is MeleeWeapon && runtimeType == other.runtimeType && length == other.length;

  @override
  int get hashCode => super.hashCode ^ length.hashCode;

  @override
  String toString() {
    return 'MeleeWeapon{length: $length}';
  }
}
