import 'package:battle_it_out/persistence/entities/attribute.dart';
import 'package:battle_it_out/persistence/entities/dto.dart';

class Talent extends DTO {
  int id;
  String name;
  Attribute? attribute;
  int? constLvl;
  String? description;
  bool grouped;

  int currentLvl = 0;
  bool advancable = false;

  Talent(
      {required this.id,
      required this.name,
      this.attribute,
      this.constLvl,
      this.description,
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
      "DESCR": description,
      "GROUPED": grouped ? 1 : 0
    };
  }
}
