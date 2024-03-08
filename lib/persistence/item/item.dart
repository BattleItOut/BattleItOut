import 'package:battle_it_out/persistence/item/item_quality.dart';
import 'package:battle_it_out/utils/db_object.dart';
import 'package:flutter/foundation.dart';

class Item extends DBObject {
  String name;
  int amount;

  int? cost;
  int encumbrance;
  String? availability;
  String? category;

  List<ItemQuality> qualities = [];

  Item(
      {super.id,
      required this.name,
      required this.encumbrance,
      this.cost,
      this.availability,
      this.category,
      this.amount = 1,
      List<ItemQuality> qualities = const []}) {
    this.qualities.addAll(qualities);
  }

  bool isCommonItem() {
    return true;
  }

  void addQuality(ItemQuality quality) {
    qualities.add(quality);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Item &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          amount == other.amount &&
          cost == other.cost &&
          encumbrance == other.encumbrance &&
          availability == other.availability &&
          category == other.category &&
          listEquals(qualities, other.qualities);

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      amount.hashCode ^
      cost.hashCode ^
      encumbrance.hashCode ^
      availability.hashCode ^
      category.hashCode ^
      qualities.hashCode;
}
