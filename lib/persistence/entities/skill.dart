import 'package:battle_it_out/persistence/entities/attribute.dart';
import 'package:battle_it_out/persistence/entities/dto.dart';

class Skill extends DTO {
  int id;
  String name;
  bool isGroup;
  BaseSkill baseSkill;

  int advances = 0;
  bool earning = false;
  bool advancable = false;

  Skill(
      {required this.id,
      required this.name,
      required this.isGroup,
      required this.baseSkill});

  String? getSpecialityName() {
    final firstIndex = name.indexOf("(");
    final lastIndex = name.indexOf(")");
    if (firstIndex != -1 && lastIndex != -1) {
      return name.substring(firstIndex + 1, lastIndex);
    } else {
      return null;
    }
  }

  int getTotalValue() {
    return baseSkill.getTotalValue() + advances;
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
      "IS_GROUP": isGroup ? 1 : 0,
      "BASE_SKILL": baseSkill.id
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