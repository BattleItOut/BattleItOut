import 'package:battle_it_out/persistence/DTO/item_quality.dart';

class Armour {
  int id;
  String name;
  int headAP;
  int bodyAP;
  int armsAP;
  int legsAP;
  List<ItemQuality> qualities;

  Armour(
      {required this.id,
        required this.name,
        required this.headAP,
        required this.bodyAP,
        required this.armsAP,
        required this.legsAP,
        this.qualities = const []});

  @override
  String toString() {
    return "Skill(id=$id, name=$name, AP=$headAP/$bodyAP/$armsAP/$legsAP))";
  }
}