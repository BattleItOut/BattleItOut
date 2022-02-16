import 'package:battle_it_out/persistence/entities/dto.dart';
import 'package:battle_it_out/persistence/entities/item_quality.dart';

abstract class Item extends DTO {
  int id;
  String name;
  List<ItemQuality> qualities;

  Item({required this.id, required this.name, this.qualities = const []});

  void addQuality(ItemQuality quality) {
    qualities.add(quality);
  }
}
