import 'package:battle_it_out/persistence/entities/item_quality.dart';

class Armour {
  int id;
  String name;
  int headAP;
  int bodyAP;
  int leftArmAP;
  int rightArmAP;
  int leftLegAP;
  int rightLegAP;
  List<ItemQuality> qualities;

  Armour(
      {required this.id,
      required this.name,
      required this.headAP,
      required this.bodyAP,
      required this.leftArmAP,
      required this.rightArmAP,
      required this.leftLegAP,
      required this.rightLegAP,
      this.qualities = const []});

  @override
  String toString() {
    return "Armour ($id, $name, $headAP/$bodyAP/$leftArmAP/$rightArmAP/$leftLegAP/$rightLegAP))";
  }
}
