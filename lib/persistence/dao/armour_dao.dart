import 'package:battle_it_out/persistence/dao/item_dao.dart';
import 'package:battle_it_out/persistence/entities/armour.dart';

class ArmourDAO extends ItemDAO<Armour> {
  @override
  get tableName => 'armour';
  @override
  get qualitiesTableName => 'armour_qualities';

  @override
  Future<Armour> fromMap(Map<String, dynamic> map, [Map overrideMap = const {}]) async {
    return Armour(
        id: map["ID"],
        name: map["NAME"],
        headAP: map["HEAD_AP"],
        bodyAP: map["BODY_AP"],
        leftArmAP: map["LEFT_ARM_AP"],
        rightArmAP: map["RIGHT_ARM_AP"],
        leftLegAP: map["LEFT_LEG_AP"],
        rightLegAP: map["RIGHT_LEG_AP"],
        itemCategory: map["ITEM_CATEGORY"],
        qualities: await getQualities(map["ID"]));
  }
}
