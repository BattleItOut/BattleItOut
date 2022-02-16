import 'package:battle_it_out/persistence/entities/item.dart';
import 'package:battle_it_out/persistence/entities/skill.dart';

class RangedWeapon extends Item {
  String range;
  bool strengthBonus;
  int damage;
  Skill? skill;

  int ammunition;

  RangedWeapon(
      {required id,
      required name,
      required this.range,
      required this.strengthBonus,
      required this.damage,
      required this.skill,
      qualities = const [],
      this.ammunition = 0})
      : super(id: id, name: name, qualities: qualities);

  @override
  Map<String, dynamic> toMap() {
    return {
      "ID": id,
      "NAME": name,
      "WEAPON_RANGE": range,
      "DAMAGE": damage,
      "STRENGTH_BONUS": strengthBonus,
      "SKILL": skill!.id
    };
  }
}
