import 'package:battle_it_out/utils/db_object.dart';
import 'package:battle_it_out/utils/factory.dart';

class AttributePartial extends DBObject {
  String? name;
  String? shortName;
  String? description;
  bool? canRoll;
  int? importance;

  int? base;
  int? advances;
  bool? canAdvance;

  AttributePartial(
      {super.id,
      this.name,
      this.shortName,
      this.description,
      this.canRoll,
      this.importance,
      this.base,
      this.advances,
      this.canAdvance});

  Attribute toAttribute() {
    return Attribute(
        id: id,
        name: name!,
        shortName: shortName!,
        description: description!,
        importance: importance!,
        base: base!,
        advances: advances!,
        canRoll: canRoll!,
        canAdvance: canAdvance!);
  }

  AttributePartial.from(Attribute? attribute)
      : this(
            id: attribute?.id,
            name: attribute?.name,
            shortName: attribute?.shortName,
            description: attribute?.description,
            importance: attribute?.importance,
            base: attribute?.base,
            advances: attribute?.advances,
            canRoll: attribute?.canRoll,
            canAdvance: attribute?.canAdvance);

  @override
  List<Object?> get props =>
      super.props..addAll([name, shortName, description, canRoll, importance, base, advances, canAdvance]);

  bool compareTo(Attribute? attribute) {
    try {
      return toAttribute() == attribute;
    } on TypeError catch (_) {
      return false;
    }
  }
}

class Attribute extends DBObject {
  String name;
  String shortName;
  String description;
  bool canRoll;
  int importance;

  int base;
  int advances;
  bool canAdvance;

  Attribute(
      {super.id,
      required this.name,
      required this.shortName,
      required this.description,
      required this.canRoll,
      required this.importance,
      this.base = 0,
      this.advances = 0,
      this.canAdvance = false});

  static Attribute copy(Attribute attribute) {
    return Attribute(
        id: attribute.id,
        name: attribute.name,
        shortName: attribute.shortName,
        description: attribute.description,
        canRoll: attribute.canRoll,
        importance: attribute.importance,
        base: attribute.base,
        advances: attribute.advances,
        canAdvance: attribute.canAdvance);
  }

  int getTotalValue() {
    return base + advances;
  }

  int getTotalBonus() {
    return getTotalValue() ~/ 10;
  }

  @override
  List<Object?> get props => super.props..addAll([name, shortName, description, canRoll, importance]);
}

class AttributeFactory extends Factory<Attribute> {
  @override
  get tableName => 'attributes';

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
