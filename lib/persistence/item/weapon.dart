import 'package:battle_it_out/persistence/attribute.dart';
import 'package:battle_it_out/persistence/item/item.dart';
import 'package:battle_it_out/persistence/skill/skill.dart';

abstract class Weapon extends Item with SpecialItem {
  int damage;
  Attribute? damageAttribute;
  Skill? skill;
  bool twoHanded;

  Weapon({
    super.id,
    required super.name,
    required this.damage,
    this.twoHanded = false,
    this.damageAttribute,
    this.skill,
    super.category,
    super.qualities,
  }) : super(encumbrance: 0);

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
          skill == other.skill &&
          twoHanded == other.twoHanded;

  @override
  int get hashCode => super.hashCode ^ damage.hashCode ^ damageAttribute.hashCode ^ skill.hashCode ^ twoHanded.hashCode;
}
