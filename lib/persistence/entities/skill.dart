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

  Skill(
      {required this.id,
      required this.name,
      required this.specialisation,
      required this.baseSkill});

  bool isGroup() {
    return baseSkill == null;
  }

  bool isAdvanced() {
    return baseSkill!.isAdvanced;
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
    return {
      "ID": id,
      "NAME": name,
      "SPECIALISATION": specialisation,
      "BASE_SKILL": baseSkill?.id
    };
  }
}

class BaseSkill extends DTO {
  int id;
  String name;
  String description;
  bool isAdvanced;
  Attribute? attribute;

  BaseSkill({required this.id, required this.name, required this.description, required this.isAdvanced, this.attribute});

  int getTotalValue() {
    return attribute!.getTotalValue();
  }

  Attribute? getAttribute() {
    return attribute;
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      "ID": id,
      "NAME": name,
      "DESCRIPTION": description,
      "IS_ADVANCED": isAdvanced ? 1 : 0,
      "ATTRIBUTE_ID": attribute?.id
    };
  }
}