import 'package:battle_it_out/persistence/entities/item.dart';

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
      qualities = const []})
      : super(id: id, name: name, qualities: qualities);

  @override
  String toString() {
    return "Armour ($id, $name, $headAP/$bodyAP/$leftArmAP/$rightArmAP/$leftLegAP/$rightLegAP))";
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      "ID": id,
      "NAME": name,
      "HEAD_AP": headAP,
      "BODY_AP": bodyAP,
      "LEFT_ARM_AP": leftArmAP,
      "RIGHT_ARM_AP": rightArmAP,
      "LEFT_LEG_AP": leftLegAP,
      "RIGHT_LEG_AP": rightLegAP
    };
  }
}
