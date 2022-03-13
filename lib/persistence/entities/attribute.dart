import 'package:battle_it_out/persistence/entities/dto.dart';

class Attribute extends DTO {
  int id;
  String name;
  String shortName;
  String description;
  int rollable;
  int importance;
  int base;
  int advances = 0;

  Attribute(
      {required this.id,
      required this.name,
      required this.shortName,
      required this.description,
      required this.rollable,
      required this.importance,
      this.base = 0});

  int getTotalValue() {
    return base + advances;
  }

  int getTotalBonus() {
    return getTotalValue() ~/ 10;
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      "ID": id,
      "NAME": name,
      "SHORT_NAME": shortName,
      "DESCRIPTION": description,
      "ROLLABLE": rollable,
      "IMPORTANCE": importance
    };
  }

  @override
  String toString() {
    return "Attribute (id=$id, name=$name, base=$base, advances=$advances)";
  }
}
