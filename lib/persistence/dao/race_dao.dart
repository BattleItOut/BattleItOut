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
  Race fromMap(Map<String, dynamic> map, [Map overrideMap = const {}]) {
    return Race(
        id: overrideMap["ID"] ?? map["ID"],
        name: overrideMap["NAME"] ?? map["NAME"],
        extraPoints: overrideMap["EXTRA_POINTS"] ?? map["EXTRA_POINTS"],
        size: overrideMap["SIZE"] ?? map["SIZE"],
        source: overrideMap["SRC"] ?? map["SRC"]);
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

  Future<Subrace>? getDefaultSubrace(int? raceID) {
    if (raceID != null) {
      return SubraceDAO().getWhere(where: "RACE_ID = ? AND DEF = ?", whereArgs: [raceID, 1]);
    }
    return null;
  }
}

class SubraceDAO extends DAO<Subrace> {
  @override
  get tableName => 'subraces';

  @override
  Subrace fromMap(Map<String, dynamic> map, [Map overrideMap = const {}]) {
    return Subrace(
        id: overrideMap["ID"] ?? map["ID"],
        name: overrideMap["NAME"] ?? map["NAME"],
        randomTalents: overrideMap["RANDOM_TALENTS"] ?? map["RANDOM_TALENTS"],
        source: overrideMap["SRC"] ?? map["SRC"],
        defaultSubrace: overrideMap["DEF"] ?? map["DEF"] == 1);
  }
}
