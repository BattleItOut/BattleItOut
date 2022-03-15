import 'package:battle_it_out/persistence/dao/race_dao.dart';
import 'package:battle_it_out/persistence/entities/attribute.dart';
import 'package:battle_it_out/persistence/entities/dto.dart';

import 'size.dart';

class Race extends DTO {
  int? id;
  String name;
  Size size;
  int extraPoints;
  String source;
  Subrace? subrace;

  Map<int, Attribute>? raceAttributes;

  Race({this.id, required this.name, required this.size, this.extraPoints = 0, this.source = "Custom", this.subrace});

  Future<Map<int, Attribute>> getAttributes() async {
    if (id != null) {
      raceAttributes ??= await RaceDAO().getAttributes(id!);
      return raceAttributes!;
    }
    return {};
  }

  @override
  Map<String, dynamic> toMap() {
    return {"ID": id, "NAME": name, "EXTRA_POINTS": extraPoints, "SIZE": size.id, "SRC": source};
  }

  @override
  String toString() {
    return "Race ($id, $name)";
  }
}

class Subrace extends DTO {
  int? id;
  String name;
  String source;
  int randomTalents;
  bool defaultSubrace;

  Subrace({this.id, required this.name, this.source = "Custom", this.randomTalents = 0, this.defaultSubrace = true});

  @override
  Map<String, dynamic> toMap() {
    return {"ID": id, "NAME": name, "RANDOM_TALENTS": randomTalents, "DEF": defaultSubrace ? 1 : 0, "SRC": source};
  }

  @override
  String toString() => 'Subrace ($id, $name)';
}
