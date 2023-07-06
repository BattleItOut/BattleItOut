import 'package:battle_it_out/persistence/entities/attribute.dart';
import 'package:battle_it_out/persistence/entities/item.dart';
import 'package:battle_it_out/persistence/entities/item_quality.dart';
import 'package:battle_it_out/persistence/entities/skill.dart';

abstract class Weapon extends Item {
  int damage;
  Attribute? damageAttribute;
  Skill? skill;

  Weapon({required id, required name, required this.damage, this.damageAttribute, this.skill, List<ItemQuality> qualities = const []})
      : super(id: id, name: name, qualities: qualities);

  int getTotalDamage() {
    return damageAttribute?.getTotalBonus() ?? 0 + damage;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is Weapon &&
          runtimeType == other.runtimeType &&
          damage == other.damage &&
          damageAttribute == other.damageAttribute &&
          skill == other.skill;

  @override
  int get hashCode => super.hashCode ^ damage.hashCode ^ damageAttribute.hashCode ^ skill.hashCode;
}
