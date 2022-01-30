import 'package:battle_it_out/persistence/DTO/attribute.dart';

class Skill {
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

  Skill({
    required this.id,
    required this.name,
    required this.attribute,
    required this.description,
    required this.advanced,
    required this.grouped,
    required this.category
  });

  @override
  String toString() {
    return "Skill(id=$id, name=$name, advances=$advances)";
  }
}
