import 'package:battle_it_out/persistence/entities/item/item_quality.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

class Item {
  late String id;
  int? databaseId;
  String name;
  int count;
  int? cost;
  int encumbrance;
  String? availability;
  String? category;

  List<ItemQuality> qualities = [];

  Item(
      {String? id,
      this.databaseId,
      required this.name,
      required this.encumbrance,
      this.cost,
      this.availability,
      this.category,
      this.count = 1,
      List<ItemQuality> qualities = const []}) {
    this.qualities.addAll(qualities);
    this.id = id ?? const Uuid().v4();
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
          databaseId == other.databaseId &&
          name == other.name &&
          listEquals(qualities, other.qualities);

  @override
  int get hashCode => databaseId.hashCode ^ name.hashCode ^ qualities.hashCode;
}

mixin SpecialItem {
  bool isCommonItem() {
    return false;
  }
}
