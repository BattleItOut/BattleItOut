import 'package:battle_it_out/persistence/entities/attribute.dart';
import 'package:battle_it_out/persistence/entities/dto.dart';

class Talent extends DTO {
  int id;
  String name;
  Attribute? attribute;
  int? constLvl;
  BaseTalent? baseTalent;
  bool grouped;

  int currentLvl = 0;
  bool advancable = false;

  Talent({required this.id, required this.name, this.attribute, this.constLvl, this.baseTalent, required this.grouped});

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
  String toString() {
    return "Talent (id=$id, name=$name)";
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      "ID": id,
      "NAME": name,
      "MAX_LVL": attribute,
      "CONST_LVL": constLvl,
      "BASE_TALENT": baseTalent?.id,
      "GROUPED": grouped ? 1 : 0
    };
  }
}

class BaseTalent extends DTO {
  int id;
  String name;
  String description;
  String source;

  BaseTalent({required this.id, required this.name, required this.description, required this.source});

  @override
  Map<String, dynamic> toMap() {
    return {"ID": id, "NAME": name, "DESCRIPTION": description, "SOURCE": source};
  }
}
