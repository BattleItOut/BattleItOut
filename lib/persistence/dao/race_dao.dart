import 'package:battle_it_out/persistence/dao/attribute_dao.dart';
import 'package:battle_it_out/persistence/dao/dao.dart';
import 'package:battle_it_out/persistence/entities/attribute.dart';
import 'package:battle_it_out/persistence/entities/race.dart';
import 'package:battle_it_out/persistence/wfrp_database.dart';

class RaceDAO extends DAO<Race> {
  @override
  get tableName => 'races';

  @override
  Race fromMap(Map<String, dynamic> map, WFRPDatabase database) {
    return Race(
        id: map["ID"], name: map["NAME"], extraPoints: map["EXTRA_POINTS"], size: map["SIZE"], source: map["SRC"]);
  }

  Future<Map<int, Attribute>> getAttributes(WFRPDatabase database, int raceID) async {
    final List<Map<String, dynamic>> attributes =
        await database.database!.query("race_attributes", where: "RACE_ID = ?", whereArgs: [raceID]);

    Map<int, Attribute> attributesMap = {};
    for (var attributeMap in attributes) {
      Attribute attribute = await AttributeDAO().get(database, attributeMap['ATTR_ID']);
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
  Subrace fromMap(Map<String, dynamic> map, WFRPDatabase database) {
    return Subrace(
        id: map["ID"],
        name: map["NAME"],
        source: map["SRC"],
        randomTalents: map["RANDOM_TALENTS"],
        defaultSubrace: map["DEF"] == 1);
  }
}
