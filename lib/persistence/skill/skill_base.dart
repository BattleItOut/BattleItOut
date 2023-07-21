import 'package:battle_it_out/persistence/attribute.dart';
import 'package:battle_it_out/persistence/serializer.dart';

class BaseSkill {
  int? id;
  String name;
  String? description;
  bool advanced;
  bool grouped;
  Attribute attribute;

  BaseSkill._(
      {required this.id,
      required this.name,
      this.description,
      required this.attribute,
      required this.advanced,
      required this.grouped});

  int getTotalValue() {
    return attribute.getTotalValue();
  }

  Attribute? getAttribute() {
    return attribute;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BaseSkill &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          description == other.description &&
          advanced == other.advanced &&
          grouped == other.grouped &&
          attribute == other.attribute;

  @override
  int get hashCode =>
      id.hashCode ^ name.hashCode ^ description.hashCode ^ advanced.hashCode ^ grouped.hashCode ^ attribute.hashCode;

  @override
  String toString() {
    return "BaseSkill (id=$id, name=$name, advanced=$advanced, grouped=$grouped)";
  }
}

class BaseSkillFactory extends Factory<BaseSkill> {
  List<Attribute>? attributes;

  BaseSkillFactory([this.attributes]);

  @override
  get tableName => 'skills_base';

  @override
  Future<BaseSkill> fromMap(Map<String, dynamic> map) async {
    Attribute? attribute = attributes?.firstWhere((attribute) => attribute.id == map["ATTRIBUTE_ID"]);
    return BaseSkill._(
        id: map["ID"],
        name: map["NAME"],
        advanced: map["ADVANCED"] == 1,
        grouped: map["GROUPED"] == 1,
        description: map["DESCRIPTION"],
        attribute: attribute ?? await AttributeFactory().get(map["ATTRIBUTE_ID"]));
  }

  @override
  Future<Map<String, dynamic>> toMap(BaseSkill object, {optimised = true, database = false}) async {
    return {
      "ID": object.id,
      "NAME": object.name,
      "DESCRIPTION": object.description,
      "ADVANCED": object.advanced ? 1 : 0,
      "GROUPED": object.grouped ? 1 : 0,
      "ATTRIBUTE_ID": object.attribute.id
    };
  }
}
