import 'package:battle_it_out/persistence/entities/attribute.dart';
import 'package:battle_it_out/persistence/entities/dto.dart';

class Skill extends DTO {
  int id;
  String name;
  String? specialisation;
  BaseSkill? baseSkill;

  int advances = 0;
  bool earning = false;
  bool advancable = false;

  Skill({required this.id, required this.name, required this.specialisation, required this.baseSkill});

  bool isGroup() {
    return baseSkill == null;
  }

  bool isAdvanced() {
    return baseSkill!.advanced;
  }

  bool isSpecialised() {
    return specialisation != null;
  }

  Attribute? getAttribute() {
    return baseSkill!.getAttribute();
  }

  int getTotalValue() {
    return baseSkill!.getTotalValue() + advances;
  }

  @override
  String toString() {
    return "Skill (id=$id, name=$name, advances=$advances)";
  }

  @override
  Map<String, dynamic> toMap() {
    return {"ID": id, "NAME": name, "SPECIALISATION": specialisation, "BASE_SKILL_ID": baseSkill?.id};
  }
}

class BaseSkill extends DTO {
  int id;
  String name;
  String description;
  bool advanced;
  bool grouped;
  Attribute? attribute;

  BaseSkill(
      {required this.id, required this.name, required this.description, required this.advanced, required this.grouped, this.attribute});

  int getTotalValue() {
    return attribute!.getTotalValue();
  }

  Attribute? getAttribute() {
    return attribute;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BaseSkill &&
          id == other.id &&
          name == other.name &&
          description == other.description &&
          advanced == other.advanced &&
          grouped == other.grouped &&
          attribute == other.attribute;

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ description.hashCode ^ advanced.hashCode ^ grouped.hashCode ^ attribute.hashCode;

  @override
  Map<String, dynamic> toMap() {
    return {
      "ID": id,
      "NAME": name,
      "DESCRIPTION": description,
      "ADVANCED": advanced ? 1 : 0,
      "GROUPED": grouped ? 1 : 0,
      "ATTRIBUTE_ID": attribute?.id
    };
  }

  @override
  String toString() {
    return "BaseSkill (id=$id, name=$name, advanced=$advanced, grouped=$grouped)";
  }
}
