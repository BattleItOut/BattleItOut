import 'package:battle_it_out/persistence/dao/race_dao.dart';
import 'package:battle_it_out/persistence/entities/attribute.dart';
import 'package:battle_it_out/persistence/entities/dto.dart';

class Race extends DTO {
  int id;
  String name;
  int size;
  int extraPoints;
  String source;
  Subrace? subrace;

  Map<int, Attribute>? raceAttributes;

  Race(
      {required this.id,
      required this.name,
      required this.size,
      required this.extraPoints,
      required this.source,
      this.subrace});

  Future<Map<int, Attribute>> getAttributes() async {
    raceAttributes ??= await RaceDAO().getAttributes(id);
    return raceAttributes!;
  }

  @override
  Map<String, dynamic> toMap() {
    return {"ID": id, "NAME": name, "EXTRA_POINTS": extraPoints, "SIZE": size, "SRC": source};
  }

  @override
  String toString() {
    return "Race ($id, $name)";
  }
}

class Subrace extends DTO {
  int id;
  String name;
  String source;
  int randomTalents;
  bool defaultSubrace;

  Subrace(
      {required this.id,
      required this.name,
      required this.source,
      required this.randomTalents,
      required this.defaultSubrace});

  @override
  Map<String, dynamic> toMap() {
    return {"ID": id, "NAME": name, "RANDOM_TALENTS": randomTalents, "DEF": defaultSubrace ? 1 : 0, "SRC": source};
  }

  @override
  String toString() => 'Subrace ($id, $name)';
}