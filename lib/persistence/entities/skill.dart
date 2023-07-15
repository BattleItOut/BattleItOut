import 'package:battle_it_out/persistence/entities/attribute.dart';

class Skill {
  int id;
  String name;
  String? specialisation;
  int? baseSkillID;
  BaseSkill? baseSkill;

  int advances;
  bool earning;
  bool canAdvance;

  Skill(
      {required this.id,
      required this.name,
      required this.specialisation,
      this.advances = 0,
      this.earning = false,
      this.canAdvance = false,
      this.baseSkill});

  bool isGroup() {
    return baseSkill == null;
  }

  bool isAdvanced() {
    return baseSkill!.advanced;
  }

  bool isSpecialised() {
    return specialisation != null;
  }

  bool isImportant() {
    return advances != 0 || canAdvance || earning;
  }

  Attribute? getAttribute() {
    return baseSkill!.getAttribute();
  }

  int getTotalValue() {
    return baseSkill!.getTotalValue() + advances;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Skill &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          specialisation == other.specialisation &&
          baseSkillID == other.baseSkillID;

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ specialisation.hashCode ^ baseSkillID.hashCode;

  @override
  String toString() {
    return "Skill (id=$id, name=$name, advances=$advances)";
  }
}

class BaseSkill {
  int? id;
  String name;
  String? description;
  bool advanced;
  bool grouped;
  int? attributeID;
  Attribute? attribute;

  BaseSkill(
      {required this.id,
      required this.name,
      required this.advanced,
      required this.grouped,
      this.description,
      this.attribute});

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
          attributeID == other.attributeID;

  @override
  int get hashCode =>
      id.hashCode ^ name.hashCode ^ description.hashCode ^ advanced.hashCode ^ grouped.hashCode ^ attributeID.hashCode;

  @override
  String toString() {
    return "BaseSkill (id=$id, name=$name, advanced=$advanced, grouped=$grouped)";
  }
}
