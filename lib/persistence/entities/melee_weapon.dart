import 'package:battle_it_out/persistence/entities/item_quality.dart';
import 'package:battle_it_out/persistence/entities/weapon.dart';
import 'package:battle_it_out/persistence/entities/weapon_length.dart';

class MeleeWeapon extends Weapon {
  WeaponLength length;

  MeleeWeapon({id, required name, required this.length, required damage, required twoHanded, damageAttribute, skill, itemCategory, List<ItemQuality> qualities = const []})
      : super(id: id, name: name, qualities: qualities, damage: damage, twoHanded: twoHanded, damageAttribute: damageAttribute, itemCategory: itemCategory, skill: skill);

  int getTotalSkillValue() {
    return skill!.getTotalValue();
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other && other is MeleeWeapon && runtimeType == other.runtimeType && length == other.length;

  @override
  int get hashCode => super.hashCode ^ length.hashCode;
}
