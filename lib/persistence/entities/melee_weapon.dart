import 'package:battle_it_out/persistence/entities/item.dart';
import 'package:battle_it_out/persistence/entities/skill.dart';

class MeleeWeapon extends Item {
  int length;
  int damage;
  Skill? skill;

  MeleeWeapon(
      {required id,
      required name,
      required this.length,
      required this.damage,
      required this.skill,
      qualities = const []})
      : super(id: id, name: name, qualities: qualities);

  @override
  Map<String, dynamic> toMap() {
    return {"ID": id, "NAME": name, "LENGTH": length, "DAMAGE": damage, "SKILL": skill?.id};
  }
}
