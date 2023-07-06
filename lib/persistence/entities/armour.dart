import 'package:battle_it_out/persistence/entities/item.dart';
import 'package:battle_it_out/persistence/entities/item_quality.dart';

class Armour extends Item {
  int headAP;
  int bodyAP;
  int leftArmAP;
  int rightArmAP;
  int leftLegAP;
  int rightLegAP;

  Armour(
      {required id,
      required name,
      required this.headAP,
      required this.bodyAP,
      required this.leftArmAP,
      required this.rightArmAP,
      required this.leftLegAP,
      required this.rightLegAP,
      List<ItemQuality> qualities = const []})
      : super(id: id, name: name, qualities: qualities);


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
          rightLegAP == other.rightLegAP;

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
