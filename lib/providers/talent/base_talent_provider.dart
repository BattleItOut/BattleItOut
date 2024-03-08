import 'package:battle_it_out/persistence/attribute.dart';
import 'package:battle_it_out/persistence/talent/talent_base.dart';
import 'package:battle_it_out/utils/factory.dart';
import 'package:collection/collection.dart';

class BaseTalentRepository extends Repository<BaseTalent> {
  List<Attribute>? attributes;

  BaseTalentRepository([this.attributes]);

  @override
  get tableName => 'talents_base';

  @override
  Future<BaseTalent> fromDatabase(Map<String, dynamic> map) async {
    Attribute? attribute;
    if (map["MAX_LVL"] != null) {
      attribute = attributes?.firstWhereOrNull((attribute) => attribute.id == map["MAX_LVL"]);
    }
    return BaseTalent(
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
