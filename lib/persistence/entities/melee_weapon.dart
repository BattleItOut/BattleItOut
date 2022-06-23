import 'package:battle_it_out/persistence/entities/weapon.dart';
import 'package:battle_it_out/persistence/entities/weapon_length.dart';

class MeleeWeapon extends Weapon {
  WeaponLength length;

  MeleeWeapon({required id, required name, required this.length, required damage, damageAttribute, skill, qualities})
      : super(id: id, name: name, qualities: qualities, damage: damage, damageAttribute: damageAttribute, skill: skill);

  int getTotalSkillValue() {
    return skill!.getTotalValue();
  }

  Map<String, dynamic> toMap() {
    return {
      "ID": id,
      "NAME": name,
      "LENGTH": length.id,
      "DAMAGE": damage,
      "SKILL": skill?.id,
      "DAMAGE_ATTRIBUTE": damageAttribute?.id
    };
  }
}
