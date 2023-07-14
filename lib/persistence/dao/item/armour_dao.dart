import 'package:battle_it_out/persistence/dao/item/item_dao.dart';
import 'package:battle_it_out/persistence/dao/item/item_quality_dao.dart';
import 'package:battle_it_out/persistence/entities/item/armour.dart';
import 'package:battle_it_out/persistence/entities/item/item_quality.dart';

class ArmourFactory extends ItemFactory<Armour> {
  @override
  get tableName => 'armour';
  @override
  get qualitiesTableName => 'item_qualities';
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
  Future<Armour> fromMap(Map<String, dynamic> map) async {
    Armour armour = Armour(
        id: map["ID"] ?? await getNextId(),
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
  Future<Map<String, dynamic>> toMap(Armour object, {optimised = true, database = false}) async {
    Map<String, dynamic> map = {
      "ID": object.id,
      "NAME": object.name,
      "HEAD_AP": object.headAP,
      "BODY_AP": object.bodyAP,
      "LEFT_ARM_AP": object.leftArmAP,
      "RIGHT_ARM_AP": object.rightArmAP,
      "LEFT_LEG_AP": object.leftLegAP,
      "RIGHT_LEG_AP": object.rightLegAP,
      "ITEM_CATEGORY": object.category
    };
    if (!database) {
      List<Map<String, dynamic>> qualitiesMap = [
        for (ItemQuality quality in object.qualities.where((e) => e.mapNeeded))
          await ItemQualityFactory().toMap(quality)
      ];
      if (qualitiesMap.isNotEmpty) {
        map["QUALITIES"] = qualitiesMap;
      }
      if (optimised) {
        map = await optimise(map);
      }
    }
    return map;
  }
}
