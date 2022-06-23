import 'package:battle_it_out/persistence/dao/serializer.dart';
import 'package:battle_it_out/persistence/dao/size_dao.dart';
import 'package:battle_it_out/persistence/entities/race.dart';

class RaceFactory extends Factory<Race> {
  @override
  get tableName => 'races';

  @override
  Future<Race> fromMap(Map<String, dynamic> map) async {
    Race race = Race(
        id: map["ID"],
        name: map["NAME"],
        extraPoints: map["EXTRA_POINTS"] ?? 0,
        source: map["SRC"] ?? 'Custom',
        size: await SizeFactory().get(map["SIZE"]));
    if (map["SUBRACE"] != null) {
      race.subrace = await SubraceFactory().create(map["SUBRACE"]);
    } else if (map["ID"] != null) {
      race.subrace = await SubraceFactory().getWhere(where: "RACE_ID = ? AND DEF = ?", whereArgs: [map["ID"], 1]);
    }
    return race;
  }

  @override
  Map<String, dynamic> toMap(Race object) {
    Map<String, dynamic> map = {
      "ID": object.id,
      "NAME": object.name,
      "EXTRA_POINTS": object.extraPoints,
      "SIZE": object.size.id,
      "SRC": object.source
    };
    if (object.subrace != null) {
      map["SUBRACE"] = SubraceFactory().toMap(object.subrace!);
    }
    return map;
  }
}

class SubraceFactory extends Factory<Subrace> {
  @override
  get tableName => 'subraces';

  @override
  Subrace fromMap(Map<String, dynamic> map) {
    return Subrace(
        id: map["ID"],
        name: map["NAME"],
        randomTalents: map["RANDOM_TALENTS"] ?? 0,
        source: map["SRC"] ?? 'Custom',
        defaultSubrace: map["DEF"] == 1
    );
  }

  @override
  Map<String, dynamic> toMap(Subrace object) {
    return {
        "ID": object.id,
        "NAME": object.name,
        "RANDOM_TALENTS": object.randomTalents,
        "SRC": object.source,
        "DEF": object.defaultSubrace ? 1 : 0
    };
  }
}
