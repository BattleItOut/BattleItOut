import 'package:battle_it_out/persistence/entities/dto.dart';

class ItemQuality extends DTO {
  int id;
  String name;
  bool positive;
  String equipment;
  String description;
  int? value;

  ItemQuality(
      {required this.id,
      required this.name,
      required this.positive,
      required this.equipment,
      required this.description,
      this.value});

  @override
  String toString() {
    if (value == null) {
      return "Quality (id=$id, name=$name)";
    } else {
      return "Quality (id=$id, name=$name $value)";
    }
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      "ID": id,
      "NAME": name,
      "POSITIVE": positive ? 1 : 0,
      "EQUIPMENT": equipment,
      "DESCRIPTION": description,
      "VALUE": value
    };
  }
}
