import 'package:battle_it_out/persistence/dao/item_dao.dart';
import 'package:battle_it_out/persistence/entities/armour.dart';
import 'package:battle_it_out/persistence/entities/item_quality.dart';

import 'item_quality_dao.dart';

class ArmourFactory extends ItemFactory<Armour> {
  @override
  get tableName => 'armour';
  @override
  get qualitiesTableName => 'armour_qualities';
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
  Future<Armour> fromMap(Map<String, dynamic> map) async {
    defaultValues.forEach((key, value) {
      map.putIfAbsent(key, () => value);
    });
    Armour armour = Armour(
        id: map["ID"],
        name: map["NAME"],
        headAP: map["HEAD_AP"],
        bodyAP: map["BODY_AP"],
        leftArmAP: map["LEFT_ARM_AP"],
        rightArmAP: map["RIGHT_ARM_AP"],
        leftLegAP: map["LEFT_LEG_AP"],
        rightLegAP: map["RIGHT_LEG_AP"]);
    if (armour.id != null) {
      armour.qualities = await getQualities(map["ID"]);
    }
    if (map["QUALITIES"] != null) {
      armour.qualities.addAll([
        for (map in map["QUALITIES"]) await ItemQualityFactory().create(map)
      ]);
    }
    return armour;
  }

  @override
  Future<Map<String, dynamic>> toMap(Armour object, [optimised = true]) async {
    Map<String, dynamic> map = {
      "ID": object.id,
      "NAME": object.name,
      "HEAD_AP": object.headAP,
      "BODY_AP": object.bodyAP,
      "LEFT_ARM_AP": object.leftArmAP,
      "RIGHT_ARM_AP": object.rightArmAP,
      "LEFT_LEG_AP": object.leftLegAP,
      "RIGHT_LEG_AP": object.rightArmAP,
      "ITEM_CATEGORY": object.category,
      "QUALITIES": [
        for (ItemQuality quality in object.qualities.where((e) => e.mapNeeded))
          await ItemQualityFactory().toMap(quality)
      ]
    };
    if (optimised) {
      map = await optimise(map);
      if (object.qualities.isEmpty) {
        map.remove("QUALITIES");
      }
    }
    return map;
  }
}
