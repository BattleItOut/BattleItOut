import 'package:battle_it_out/persistence/entities/attribute.dart';
import 'package:uuid/uuid.dart';

class Skill {
  late String id;
  int? databaseId;
  String name;
  String? specialisation;
  BaseSkill? baseSkill;

  int advances;
  bool earning;
  bool canAdvance;

  Skill(
      {String? id,
      this.databaseId,
      required this.name,
      required this.specialisation,
      this.advances = 0,
      this.earning = false,
      this.canAdvance = false,
      this.baseSkill}) {
    this.id = id ?? const Uuid().v4();
  }

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
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Skill &&
          runtimeType == other.runtimeType &&
          databaseId == other.databaseId &&
          name == other.name &&
          specialisation == other.specialisation;

  @override
  int get hashCode => databaseId.hashCode ^ name.hashCode ^ specialisation.hashCode;

  @override
  String toString() {
    return "Skill (id=$id, name=$name, advances=$advances)";
  }
}

class BaseSkill {
  late String id;
  int? databaseId;
  String name;
  String description;
  bool advanced;
  bool grouped;
  Attribute? attribute;

  BaseSkill(
      {String? id,
      this.databaseId,
      required this.name,
      required this.description,
      required this.advanced,
      required this.grouped,
      this.attribute}) {
    this.id = id ?? const Uuid().v4();
  }

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
          databaseId == other.databaseId &&
          name == other.name &&
          description == other.description &&
          advanced == other.advanced &&
          grouped == other.grouped;

  @override
  int get hashCode => databaseId.hashCode ^ name.hashCode ^ description.hashCode ^ advanced.hashCode ^ grouped.hashCode;

  @override
  String toString() {
    return "BaseSkill (id=$id, name=$name, advanced=$advanced, grouped=$grouped)";
  }
}
