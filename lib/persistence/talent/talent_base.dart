import 'package:battle_it_out/persistence/attribute.dart';
import 'package:battle_it_out/utils/db_object.dart';
import 'package:battle_it_out/utils/factory.dart';
import 'package:collection/collection.dart';

class BaseTalent extends DBObject {
  String name;
  String? description;
  String source;
  Attribute? attribute;
  int? attributeID;
  int? constLvl;
  bool grouped;

  BaseTalent._(
      {super.id,
      required this.name,
      required this.source,
      this.description,
      this.attribute,
      this.constLvl,
      required this.grouped});

  int? getMaxLvl() {
    if (attribute != null) {
      return attribute!.getTotalValue() ~/ 10;
    }
    if (constLvl != null) {
      return constLvl;
    }
    return null;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BaseTalent &&
          id == other.id &&
          name == other.name &&
          description == other.description &&
          source == other.source &&
          grouped == other.grouped &&
          attributeID == other.attributeID &&
          constLvl == other.constLvl;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      description.hashCode ^
      constLvl.hashCode ^
      source.hashCode ^
      grouped.hashCode ^
      attributeID.hashCode;
}

class BaseTalentFactory extends Factory<BaseTalent> {
  List<Attribute>? attributes;

  BaseTalentFactory([this.attributes]);

  @override
  get tableName => 'talents_base';

  @override
  Future<BaseTalent> fromDatabase(Map<String, dynamic> map) async {
    Attribute? attribute;
    if (map["MAX_LVL"] != null) {
      attribute = attributes?.firstWhereOrNull((attribute) => attribute.id == map["MAX_LVL"]);
    }
    return BaseTalent._(
        id: map['ID'],
        name: map['NAME'],
        description: map['DESCRIPTION'],
        source: map['SOURCE'],
        attribute: attribute,
        constLvl: map['CONST_LVL'],
        grouped: map["GROUPED"] == 1 ? true : false);
  }

  @override
  Future<Map<String, dynamic>> toDatabase(BaseTalent object) async {
    return {
      "ID": object.id,
      "NAME": object.name,
      "DESCRIPTION": object.description,
      "SOURCE": object.source,
      "CONST_LVL": object.constLvl,
      "GROUPED": object.grouped ? 1 : 0
    };
  }

  @override
  Future<Map<String, dynamic>> toMap(BaseTalent object, {optimised = true, database = false}) async {
    return {
      "ID": object.id,
      "NAME": object.name,
      "DESCRIPTION": object.description,
      "SOURCE": object.source,
      "CONST_LVL": object.constLvl,
      "GROUPED": object.grouped ? 1 : 0
    };
  }
}
