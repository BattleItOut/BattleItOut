import 'package:battle_it_out/persistence/entities/item/item_quality.dart';
import 'package:flutter/foundation.dart';

class Item {
  int id;
  String name;
  int count;

  int? cost;
  int encumbrance;
  String? availability;
  String? category;

  List<ItemQuality> qualities = [];

  Item({required this.id,
    required this.name,
    required this.encumbrance,
    this.cost,
    this.availability,
    this.category,
    this.count = 1,
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
          other is Item && runtimeType == other.runtimeType && id == other.id && name == other.name &&
              count == other.count && cost == other.cost && encumbrance == other.encumbrance &&
              availability == other.availability && category == other.category && listEquals(qualities, other.qualities);

  @override
  int get hashCode =>
      id.hashCode ^ name.hashCode ^ count.hashCode ^ cost.hashCode ^ encumbrance.hashCode ^ availability
          .hashCode ^ category.hashCode ^ qualities.hashCode;
}

mixin SpecialItem {
  bool isCommonItem() {
    return false;
  }
}
