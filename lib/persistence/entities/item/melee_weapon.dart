import 'package:battle_it_out/persistence/entities/attribute.dart';
import 'package:battle_it_out/persistence/entities/item/item_quality.dart';
import 'package:battle_it_out/persistence/entities/item/weapon.dart';
import 'package:battle_it_out/persistence/entities/item/weapon_length.dart';
import 'package:battle_it_out/persistence/entities/skill.dart';

class MeleeWeapon extends Weapon {
  WeaponLength length;

  MeleeWeapon(
      {required name,
      required this.length,
      required damage,
      required twoHanded,
      String? id,
      int? databaseId,
      Attribute? damageAttribute,
      Skill? skill,
      String? category,
      List<ItemQuality> qualities = const []})
      : super(
            id: id,
            databaseId: databaseId,
            name: name,
            qualities: qualities,
            damage: damage,
            twoHanded: twoHanded,
            damageAttribute: damageAttribute,
            category: category ?? "MELEE_WEAPONS",
            skill: skill);

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
