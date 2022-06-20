import 'package:battle_it_out/persistence/entities/dto.dart';
import 'package:battle_it_out/persistence/entities/item_quality.dart';

class Item extends DTO {
  int id;
  String name;

  int? cost;
  int encumbrance;
  String? availability;
  String? category;

  List<ItemQuality> qualities = [];

  Item(
      {required this.id,
      required this.name,
      required this.encumbrance,
      this.cost,
      this.availability,
      this.category,
      List<ItemQuality> qualities = const []}) {
    this.qualities.addAll(qualities);
  }

  void addQuality(ItemQuality quality) {
    qualities.add(quality);
  }

  @override
  Map<String, dynamic> toMap() {
    return {"ID": id, "NAME": name, "CATEGORY": category};
  }
}
