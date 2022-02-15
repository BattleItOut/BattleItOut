import 'package:battle_it_out/persistence/entities/dto.dart';
import 'package:battle_it_out/persistence/entities/item_quality.dart';
import 'package:battle_it_out/persistence/entities/skill.dart';

class RangedWeapon extends DTO {
  int id;
  String name;
  String range;
  bool strengthBonus;
  int damage;
  Skill? skill;
  List<ItemQuality> qualities = [];

  int ammunition;

  RangedWeapon(
      {required this.id,
      required this.name,
      required this.range,
      required this.strengthBonus,
      required this.damage,
      required this.skill,
      this.qualities = const [],
      this.ammunition = 0});

  void addQuality(ItemQuality quality) {
    qualities.add(quality);
  }

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
