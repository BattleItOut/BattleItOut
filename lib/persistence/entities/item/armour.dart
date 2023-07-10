import 'package:battle_it_out/persistence/entities/item/item.dart';
import 'package:battle_it_out/persistence/entities/item/item_quality.dart';
import 'package:flutter/foundation.dart';

class Armour extends Item with SpecialItem {
  int headAP;
  int bodyAP;
  int leftArmAP;
  int rightArmAP;
  int leftLegAP;
  int rightLegAP;

  Armour(
      {required this.headAP,
      required this.bodyAP,
      required this.leftArmAP,
      required this.rightArmAP,
      required this.leftLegAP,
      required this.rightLegAP,
      String? id,
      int? databaseId,
      required String name,
      int count = 1,
      int encumbrance = 0,
      String category = "ARMOUR",
      List<ItemQuality> qualities = const []})
      : super(
            id: id,
            databaseId: databaseId,
            name: name,
            count: count,
            encumbrance: encumbrance,
            category: category,
            qualities: qualities);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is Armour &&
          runtimeType == other.runtimeType &&
          headAP == other.headAP &&
          bodyAP == other.bodyAP &&
          leftArmAP == other.leftArmAP &&
          rightArmAP == other.rightArmAP &&
          leftLegAP == other.leftLegAP &&
          rightLegAP == other.rightLegAP &&
          listEquals(qualities, other.qualities);

  @override
  int get hashCode =>
      super.hashCode ^
      headAP.hashCode ^
      bodyAP.hashCode ^
      leftArmAP.hashCode ^
      rightArmAP.hashCode ^
      leftLegAP.hashCode ^
      rightLegAP.hashCode;

  @override
  String toString() {
    return "Armour ($id, $name, $headAP/$bodyAP/$leftArmAP/$rightArmAP/$leftLegAP/$rightLegAP))";
  }
}
