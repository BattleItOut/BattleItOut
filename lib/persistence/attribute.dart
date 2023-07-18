import 'package:battle_it_out/persistence/serializer.dart';

class Attribute {
  int id;
  String name;
  String shortName;
  String description;
  bool canRoll;
  int importance;

  int base;
  int advances;
  bool canAdvance;

  Attribute._(
      {required this.id,
      required this.name,
      required this.shortName,
      required this.description,
      required this.canRoll,
      required this.importance,
      this.base = 0,
      this.advances = 0,
      this.canAdvance = false});

  int getTotalValue() {
    return base + advances;
  }

  int getTotalBonus() {
    return getTotalValue() ~/ 10;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Attribute &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          shortName == other.shortName &&
          description == other.description &&
          canRoll == other.canRoll &&
          importance == other.importance;

  @override
  int get hashCode =>
      id.hashCode ^ name.hashCode ^ shortName.hashCode ^ description.hashCode ^ canRoll.hashCode ^ importance.hashCode;

  @override
  String toString() {
    return "Attribute (id=$id, name=$name, base=$base, advances=$advances)";
  }
}

class AttributeFactory extends Factory<Attribute> {
  @override
  get tableName => 'attributes';

  @override
  Future<Attribute> fromMap(Map<String, dynamic> map) async {
    return Attribute._(
        id: map['ID'],
        name: map['NAME'],
        shortName: map["SHORT_NAME"],
        description: map["DESCRIPTION"],
        canRoll: map['CAN_ROLL'] == 1,
        importance: map['IMPORTANCE'],
        base: map["BASE"] ?? 0,
        advances: map["ADVANCES"] ?? 0,
        canAdvance: map["CAN_ADVANCE"] ?? false);
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
      "CAN_ADVANCE": object.canAdvance
    };
    if (optimised) {
      map = await optimise(map);
    }
    return map;
  }
}