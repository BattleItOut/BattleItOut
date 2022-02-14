import 'package:battle_it_out/persistence/entities/entity.dart';

class Race extends Entity {
  @override
  get tableName => "races";

  int? id;
  String? name;
  int? size;
  int? extraPoints;
  String? source;

  Race({this.id, this.name, this.size, this.extraPoints, this.source});

  @override
  Map<String, dynamic> toMap() {
    return {
      "ID": id,
      "NAME": name,
      "EXTRA_POINTS": extraPoints,
      "SIZE": size,
      "SRC": source
    };
  }

  @override
  Race fromMap(Map<String, dynamic> map) {
    return Race(
        id: map["ID"], name: map["NAME"], extraPoints: map["EXTRA_POINTS"], size: map["SIZE"], source: map["SRC"]);
  }

  @override
  String toString() {
    return "Race ($id, $name)";
  }
}

class Subrace extends Entity {
  @override
  get tableName => "subraces";

  int? id;
  String? name;
  String? source;
  int? randomTalents;
  bool? defaultSubrace;

  Subrace({this.id, this.name, this.source, this.randomTalents, this.defaultSubrace});

  @override
  Map<String, dynamic> toMap() {
    return {
      "ID": id,
      "NAME": name,
      "RANDOM_TALENTS": randomTalents,
      "DEF": defaultSubrace! ? 1 : 0,
      "SRC": source
    };
  }

  @override
  Subrace fromMap(Map<String, dynamic> map) {
    return Subrace(
        id: map["ID"],
        name: map["NAME"],
        source: map["SRC"],
        randomTalents: map["RANDOM_TALENTS"],
        defaultSubrace: map["DEF"] == 1);
  }

  @override
  String toString() => 'Subrace ($id, $name)';
}
