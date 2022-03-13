import 'package:battle_it_out/persistence/entities/attribute.dart';
import 'package:battle_it_out/persistence/entities/dto.dart';

class Skill extends DTO {
  int id;
  String name;
  Attribute? attribute;
  String? description;
  bool advanced;
  bool grouped;
  String? category;

  int advances = 0;
  bool earning = false;
  bool advancable = false;

  Skill(
      {required this.id,
      required this.name,
      required this.attribute,
      required this.description,
      required this.advanced,
      required this.grouped,
      required this.category});

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
    return attribute!.getTotalValue() + advances;
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
      "ATTR_ID": attribute?.id,
      "DESCR": description,
      "ADV": advanced ? 1 : 0,
      "GROUPED": grouped ? 1 : 0,
      "CATEGORY": category
    };
  }
}
