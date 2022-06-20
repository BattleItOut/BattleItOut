import 'package:battle_it_out/persistence/entities/weapon.dart';
import 'package:battle_it_out/persistence/entities/weapon_length.dart';

class MeleeWeapon extends Weapon {
  WeaponLength length;

  MeleeWeapon(
      {required id,
      required name,
      required this.length,
      required damage,
      required twoHanded,
      damageAttribute,
      skill,
      itemCategory,
      qualities})
      : super(
            id: id,
            name: name,
            qualities: qualities,
            damage: damage,
            twoHanded: twoHanded,
            damageAttribute: damageAttribute,
            skill: skill,
            itemCategory: itemCategory);

  int getTotalSkillValue() {
    return skill!.getTotalValue();
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      "ID": id,
      "NAME": name,
      "LENGTH": length.id,
      "DAMAGE": damage,
      "SKILL": skill?.id,
      "DAMAGE_ATTRIBUTE": damageAttribute?.id,
      "TWO-HANDED": twoHanded ? 1 : 0
    };
  }
}
