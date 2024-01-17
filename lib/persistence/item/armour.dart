import 'package:battle_it_out/persistence/item/item.dart';
import 'package:battle_it_out/persistence/item/item_quality.dart';
import 'package:flutter/foundation.dart';

class Armour extends Item {
  int headAP;
  int bodyAP;
  int leftArmAP;
  int rightArmAP;
  int leftLegAP;
  int rightLegAP;

  Armour(
      {super.id,
      required super.name,
      super.amount,
      required super.encumbrance,
      required this.headAP,
      required this.bodyAP,
      required this.leftArmAP,
      required this.rightArmAP,
      required this.leftLegAP,
      required this.rightLegAP,
      super.qualities})
      : super(category: "ARMOUR");

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
          rightLegAP == other.rightLegAP &&
          listEquals(qualities, other.qualities);

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

class ArmourFactory extends ItemFactory<Armour> {
  @override
  get tableName => 'armour';
  @override
  get linkTableName => 'armour_qualities';

  @override
  Map<String, dynamic> get defaultValues => {
        "ITEM_CATEGORY": "ARMOUR",
        "HEAD_AP": 0,
        "BODY_AP": 0,
        "LEFT_ARM_AP": 0,
        "RIGHT_ARM_AP": 0,
        "LEFT_LEG_AP": 0,
        "RIGHT_LEG_AP": 0
      };

  @override
  Future<Armour> fromDatabase(Map<String, dynamic> map) async {
    return Armour(
        id: map["ID"],
        encumbrance: map["ENCUMBRANCE"],
        name: map["NAME"],
        headAP: map["HEAD_AP"],
        bodyAP: map["BODY_AP"],
        leftArmAP: map["LEFT_ARM_AP"],
        rightArmAP: map["RIGHT_ARM_AP"],
        leftLegAP: map["LEFT_LEG_AP"],
        rightLegAP: map["RIGHT_LEG_AP"]);
  }

  @override
  Future<Armour> fromMap(Map<String, dynamic> map) async {
    Armour armour = Armour(
        id: map["ID"],
        encumbrance: map["ENCUMBRANCE"],
        name: map["NAME"],
        headAP: map["HEAD_AP"],
        bodyAP: map["BODY_AP"],
        leftArmAP: map["LEFT_ARM_AP"],
        rightArmAP: map["RIGHT_ARM_AP"],
        leftLegAP: map["LEFT_LEG_AP"],
        rightLegAP: map["RIGHT_LEG_AP"]);
    if (map["ID"] != null) {
      armour.qualities = await getQualities(map["ID"]);
    }
    if (map["QUALITIES"] != null) {
      for (Map<String, dynamic> map in map["QUALITIES"]) {
        ItemQuality quality = await ItemQualityFactory().create(map);
        if (!armour.qualities.contains(quality)) {
          armour.qualities.add(quality);
        }
      }
    }
    return armour;
  }

  @override
  Future<Map<String, dynamic>> toDatabase(Armour object) async {
    return {
      "ID": object.id,
      "NAME": object.name,
      "ENCUMBRANCE": object.encumbrance,
      "HEAD_AP": object.headAP,
      "BODY_AP": object.bodyAP,
      "LEFT_ARM_AP": object.leftArmAP,
      "RIGHT_ARM_AP": object.rightArmAP,
      "LEFT_LEG_AP": object.leftLegAP,
      "RIGHT_LEG_AP": object.rightLegAP,
    };
  }

  @override
  Future<Map<String, Object?>> toMap(Armour object, {optimised = true, database = false}) async {
    Map<String, dynamic> map = {
      "ID": object.id,
      "NAME": object.name,
      "ENCUMBRANCE": object.encumbrance,
      "HEAD_AP": object.headAP,
      "BODY_AP": object.bodyAP,
      "LEFT_ARM_AP": object.leftArmAP,
      "RIGHT_ARM_AP": object.rightArmAP,
      "LEFT_LEG_AP": object.leftLegAP,
      "RIGHT_LEG_AP": object.rightLegAP,
      "ITEM_CATEGORY": object.category,
      "QUALITIES": [for (ItemQuality quality in object.qualities) await ItemQualityFactory().toDatabase(quality)]
    };
    if (optimised) {
      map = await optimise(map);
    }
    return map;
  }
}
