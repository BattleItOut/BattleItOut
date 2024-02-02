import 'package:battle_it_out/persistence/attribute.dart';
import 'package:battle_it_out/utils/factory.dart';

class AttributeProvider extends Factory<Attribute> {
  @override
  get tableName => 'attributes';

  Future<List<Attribute>> getInitialAttributes(int raceId) async {
    final List<Map<String, dynamic>> map = await getRawQuery(
        sql: "SELECT * FROM RACE_ATTRIBUTES RA JOIN ATTRIBUTES A ON (A.ID = RA.ATTR_ID) WHERE RACE_ID = ?",
        sqlArgs: [raceId]);
    List<Attribute> attributes = [];
    for (Map<String, dynamic> entry in map) {
      Attribute attribute = await fromDatabase(entry);
      attribute.base = entry["VALUE"];
      attributes.add(attribute);
    }
    return attributes;
  }

  @override
  Future<Attribute> fromDatabase(Map<String, dynamic> map) async {
    return Attribute(
        id: map['ID'],
        name: map['NAME'],
        shortName: map["SHORT_NAME"],
        description: map["DESCRIPTION"],
        canRoll: map['CAN_ROLL'] == 1,
        importance: map['IMPORTANCE'],
        base: map["BASE"] ?? 0,
        advances: map["ADVANCES"] ?? 0,
        canAdvance: map["CAN_ADVANCE"] == 1);
  }

  @override
  Future<Attribute> fromMap(Map<String, dynamic> map) async {
    return Attribute(
        id: map['ID'],
        name: map['NAME'],
        shortName: map["SHORT_NAME"],
        description: map["DESCRIPTION"],
        canRoll: map['CAN_ROLL'] == 1,
        importance: map['IMPORTANCE'],
        base: map["BASE"] ?? 0,
        advances: map["ADVANCES"] ?? 0,
        canAdvance: map["CAN_ADVANCE"] == 1);
  }

  @override
  Future<Map<String, dynamic>> toDatabase(Attribute object) async {
    return {
      "ID": object.id,
      "NAME": object.name,
      "SHORT_NAME": object.shortName,
      "DESCRIPTION": object.description,
      "IMPORTANCE": object.importance,
      "CAN_ROLL": object.canRoll ? 1 : 0
    };
  }

  @override
  Future<Map<String, dynamic>> toMap(Attribute object, {optimised = true, database = false}) async {
    Map<String, dynamic> map = {
      "ID": object.id,
      "NAME": object.name,
      "SHORT_NAME": object.shortName,
      "DESCRIPTION": object.description,
      "CAN_ROLL": object.canRoll ? 1 : 0,
      "IMPORTANCE": object.importance,
      "BASE": object.base,
      "ADVANCES": object.advances,
      "CAN_ADVANCE": object.canAdvance ? 1 : 0
    };
    if (optimised) {
      map = await optimise(map);
    }
    return map;
  }
}
