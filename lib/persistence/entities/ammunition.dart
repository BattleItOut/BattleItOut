import 'package:battle_it_out/persistence/entities/item.dart';

class Ammunition extends Item {
  double rangeModifier;
  int rangeBonus;
  int damageBonus;

  Ammunition(
      {required int id,
      required String name,
      this.rangeModifier = 1,
      this.rangeBonus = 0,
      this.damageBonus = 0,
      itemCategory,
      qualities})
      : super(id: id, name: name, encumbrance: 0, category: itemCategory, qualities: qualities);

  @override
  Map<String, dynamic> toMap() {
    return {
      "ID": id,
      "NAME": name,
      "RANGE_MOD": (rangeModifier * 100).round() / 100.0,
      "RANGE_BONUS": rangeBonus,
      "DAMAGE_BONUS": damageBonus
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Ammunition &&
          runtimeType == other.runtimeType &&
          rangeModifier == other.rangeModifier &&
          rangeBonus == other.rangeBonus &&
          damageBonus == other.damageBonus;

  @override
  int get hashCode => rangeModifier.hashCode ^ rangeBonus.hashCode ^ damageBonus.hashCode;
}
