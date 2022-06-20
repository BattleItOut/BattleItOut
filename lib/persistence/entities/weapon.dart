import 'package:battle_it_out/persistence/entities/attribute.dart';
import 'package:battle_it_out/persistence/entities/item.dart';
import 'package:battle_it_out/persistence/entities/skill.dart';

abstract class Weapon extends Item {
  int damage;
  Attribute? damageAttribute;
  Skill? skill;
  bool twoHanded;

  Weapon({
    required id,
    required name,
    required this.damage,
    required this.twoHanded,
    this.damageAttribute,
    this.skill,
    itemCategory,
    qualities,
  }) : super(id: id, name: name, category: itemCategory, encumbrance: 0, qualities: qualities);

  int getTotalDamage() {
    return damageAttribute?.getTotalBonus() ?? 0 + damage;
  }
}
