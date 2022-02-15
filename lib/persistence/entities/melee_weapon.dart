import 'package:battle_it_out/persistence/entities/dto.dart';
import 'package:battle_it_out/persistence/entities/item_quality.dart';
import 'package:battle_it_out/persistence/entities/skill.dart';

class MeleeWeapon extends DTO {
  int id;
  String name;
  int length;
  int damage;
  Skill? skill;
  List<ItemQuality> qualities;

  MeleeWeapon(
      {required this.id,
      required this.name,
      required this.length,
      required this.damage,
      required this.skill,
      required this.qualities});

  void addQuality(ItemQuality quality) {
    qualities.add(quality);
  }

  @override
  Map<String, dynamic> toMap() {
    return {"ID": id, "NAME": name, "LENGTH": length, "DAMAGE": damage, "SKILL": skill?.id};
  }
}
