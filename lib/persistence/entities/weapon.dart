import 'package:battle_it_out/persistence/entities/attribute.dart';
import 'package:battle_it_out/persistence/entities/item.dart';
import 'package:battle_it_out/persistence/entities/skill.dart';

abstract class Weapon extends Item {
  int damage;
  Attribute? damageAttribute;
  Skill? skill;

  Weapon({required id, required name, required this.damage, this.damageAttribute, this.skill, qualities})
      : super(id: id, name: name, qualities: qualities);

  int getTotalDamage() {
    return damageAttribute?.getTotalBonus() ?? 0 + damage;
  }
}
