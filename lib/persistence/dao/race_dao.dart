import 'package:battle_it_out/persistence/dao/attribute_dao.dart';
import 'package:battle_it_out/persistence/dao/dao.dart';
import 'package:battle_it_out/persistence/entities/attribute.dart';
import 'package:battle_it_out/persistence/entities/race.dart';
import 'package:battle_it_out/persistence/database_provider.dart';
import 'package:sqflite/sqflite.dart';

class RaceDAO extends DAO<Race> {
  @override
  get tableName => 'races';

  @override
  Race fromMap(Map<String, dynamic> map) {
    return Race(
        id: map["ID"], name: map["NAME"], extraPoints: map["EXTRA_POINTS"], size: map["SIZE"], source: map["SRC"]);
  }

  Future<Map<int, Attribute>> getAttributes(int raceID) async {
    Database? database = await DatabaseProvider.instance.getDatabase();
    final List<Map<String, dynamic>> attributes =
        await database!.query("race_attributes", where: "RACE_ID = ?", whereArgs: [raceID]);

    Map<int, Attribute> attributesMap = {};
    for (var attributeMap in attributes) {
      Attribute attribute = await AttributeDAO().get(attributeMap['ATTR_ID']);
      attribute.base = attributeMap["VALUE"];
      attributesMap[attribute.id] = attribute;
    }
    return attributesMap;
  }
}

class SubraceDAO extends DAO<Subrace> {
  @override
  get tableName => 'subraces';

  @override
  Subrace fromMap(Map<String, dynamic> map) {
    return Subrace(
        id: map["ID"],
        name: map["NAME"],
        source: map["SRC"],
        randomTalents: map["RANDOM_TALENTS"],
        defaultSubrace: map["DEF"] == 1);
  }
}
