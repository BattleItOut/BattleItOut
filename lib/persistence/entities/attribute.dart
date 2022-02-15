import 'package:battle_it_out/persistence/entities/dto.dart';

class Attribute extends DTO {
  int id;
  String name;
  int rollable;
  int importance;
  int base;
  int advances = 0;

  Attribute({required this.id, required this.name, required this.rollable, required this.importance, this.base = 0});

  int getTotalValue() {
    return base + advances;
  }

  @override
  Map<String, dynamic> toMap() {
    return {"ID": id, "NAME": name, "ROLLABLE": rollable, "IMPORTANCE": importance};
  }

  @override
  String toString() {
    return "Attribute (id=$id, name=$name, base=$base, advances=$advances)";
  }
}
