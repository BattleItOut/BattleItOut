import 'package:battle_it_out/persistence/dao/item_dao.dart';
import 'package:battle_it_out/persistence/dao/item_quality_dao.dart';
import 'package:battle_it_out/persistence/entities/armour.dart';
import 'package:battle_it_out/persistence/entities/item_quality.dart';

class ArmourFactory extends ItemFactory<Armour> {
  @override
  get tableName => 'armour';
  @override
  get qualitiesTableName => 'armour_qualities';

  @override
  Future<Armour> fromMap(Map<String, dynamic> map, [Map overrideMap = const {}]) async {
    Armour armour = Armour(
        id: map["ID"],
        name: map["NAME"],
        headAP: map["HEAD_AP"] ?? 0,
        bodyAP: map["BODY_AP"] ?? 0,
        leftArmAP: map["LEFT_ARM_AP"] ?? 0,
        rightArmAP: map["RIGHT_ARM_AP"] ?? 0,
        leftLegAP: map["LEFT_LEG_AP"] ?? 0,
        rightLegAP: map["RIGHT_LEG_AP"] ?? 0);
    if (armour.id != null) {
      armour.qualities = await getQualities(map["ID"]);
    } if (map["QUALITIES"] != null) {
      armour.qualities.addAll([for (map in map["QUALITIES"]) await ItemQualityFactory().create(map)]);
    }
    return armour;
  }

  @override
  Map<String, dynamic> toMap(Armour object) {
    return {
      "ID": object.id,
      "NAME": object.name,
      "HEAD_AP": object.headAP,
      "BODY_AP": object.bodyAP,
      "LEFT_ARM_AP": object.leftArmAP,
      "RIGHT_ARM_AP": object.rightArmAP,
      "LEFT_LEG_AP": object.leftLegAP,
      "RIGHT_LEG_AP": object.rightLegAP,
      "QUALITIES": [for (ItemQuality quality in object.qualities.where((e) => e.mapNeeded)) ItemQualityFactory().toMap(quality)]
    };
  }
}
