import 'package:battle_it_out/persistence/entities/item_quality.dart';
import 'package:flutter/foundation.dart';

abstract class Item {
  int? id;
  String name;
  List<ItemQuality> qualities = [];

  Item({required this.id, required this.name, List<ItemQuality> qualities = const []}) {
    this.qualities.addAll(qualities);
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
          listEquals(qualities, other.qualities);

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ qualities.hashCode;
}
