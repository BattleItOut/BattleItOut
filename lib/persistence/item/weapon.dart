import 'package:battle_it_out/persistence/attribute.dart';
import 'package:battle_it_out/persistence/item/item.dart';
import 'package:battle_it_out/persistence/skill/skill.dart';

abstract class Weapon extends Item with SpecialItem {
  int damage;
  Attribute? damageAttribute;
  Skill? skill;
  bool twoHanded;

  Weapon({
    id,
    required name,
    required this.damage,
    this.twoHanded = false,
    this.damageAttribute,
    this.skill,
    itemCategory,
    qualities,
  }) : super(id: id, name: name, category: itemCategory, encumbrance: 0, qualities: qualities);

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
