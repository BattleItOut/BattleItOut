import 'package:battle_it_out/persistence/entities/attribute.dart';
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
      qualities,
      this.ammunition = 0})
      : super(id: id, name: name, qualities: qualities, damage: damage, damageAttribute: damageAttribute, skill: skill);

  int getRange() {
    return rangeAttribute?.getTotalBonus() ?? 1 * range;
  }

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
