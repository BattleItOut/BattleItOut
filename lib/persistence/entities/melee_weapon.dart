import 'package:battle_it_out/persistence/entities/item.dart';
import 'package:battle_it_out/persistence/entities/item_quality.dart';
import 'package:battle_it_out/persistence/entities/skill.dart';
import 'package:battle_it_out/persistence/entities/weapon_length.dart';

class MeleeWeapon extends Item {
  WeaponLength length;
  int damage;
  Skill? skill;

  MeleeWeapon(
      {required id,
      required name,
      required this.length,
      required this.damage,
      required this.skill,
      qualities = const <ItemQuality>[]})
      : super(id: id, name: name, qualities: qualities);

  int getTotalSkillValue() {
    return skill!.getTotalValue();
  }

  @override
  Map<String, dynamic> toMap() {
    return {"ID": id, "NAME": name, "LENGTH": length.id, "DAMAGE": damage, "SKILL": skill?.id};
  }
}
