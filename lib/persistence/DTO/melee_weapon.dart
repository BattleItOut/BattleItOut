import 'package:battle_it_out/persistence/DTO/item_quality.dart';
import 'package:battle_it_out/persistence/DTO/skill.dart';

class MeleeWeapon {
  int id;
  String name;
  int length;
  int damage;
  Skill? skill;
  List<ItemQuality> qualities = [];

  MeleeWeapon(
      {required this.id,
      required this.name,
      required this.length,
      required this.damage,
      required this.skill,
      this.qualities = const []});

  void addQuality(ItemQuality quality) {
    qualities.add(quality);
  }
}
