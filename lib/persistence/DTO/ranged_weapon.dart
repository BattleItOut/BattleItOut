import 'package:battle_it_out/persistence/DTO/item_quality.dart';
import 'package:battle_it_out/persistence/DTO/skill.dart';

class RangedWeapon {
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
}
