import 'package:battle_it_out/persistence/dao/dao.dart';
import 'package:battle_it_out/persistence/dao/item_quality_dao.dart';
import 'package:battle_it_out/persistence/entities/armour.dart';
import 'package:battle_it_out/persistence/entities/item_quality.dart';
import 'package:battle_it_out/persistence/wfrp_database.dart';
import 'package:sqflite/sqflite.dart';

class ArmourDAO extends DAO<Armour> {
  @override
  get tableName => 'armour';

  Future<List<ItemQuality>> getQualities(int id) async {
    Database? database = await DatabaseProvider.instance.getDatabase();

    final List<Map<String, dynamic>> map =
        await database!.query("armour_qualities", where: "ARMOUR_ID = ?", whereArgs: [id]);
    List<ItemQuality> qualities = [];
    for (int i = 0; i < map.length; i++) {
      qualities.add(await ItemQualityDAO().get(map[i]["QUALITY_ID"]));
    }
    return qualities;
  }

  @override
  Future<Armour> fromMap(Map<String, dynamic> map) async {
    return Armour(
        id: map["ID"],
        name: map["NAME"],
        headAP: map["HEAD_AP"],
        bodyAP: map["BODY_AP"],
        leftArmAP: map["LEFT_ARM_AP"],
        rightArmAP: map["RIGHT_ARM_AP"],
        leftLegAP: map["LEFT_LEG_AP"],
        rightLegAP: map["RIGHT_LEG_AP"],
        qualities: await getQualities(map["ID"]));
  }
}
