import 'package:battle_it_out/persistence/dao/serializer.dart';
import 'package:battle_it_out/persistence/dao/size_dao.dart';
import 'package:battle_it_out/persistence/entities/race.dart';

class RaceFactory extends Factory<Race> {
  @override
  get tableName => 'races';

  @override
  Map<String, dynamic> get defaultValues => {"EXTRA_POINTS": 0, "SRC": "Custom"};

  getDefaultSubrace(int raceID) async {
    return SubraceFactory().getWhere(where: "RACE_ID = ? AND DEF = ?", whereArgs: [raceID, 1]);
  }

  @override
  Future<Race> fromMap(Map<String, dynamic> map) async {
    defaultValues.forEach((key, value) {
      map.putIfAbsent(key, () => value);
    });
    Race race = Race(
        databaseId: map["ID"],
        name: map["NAME"],
        extraPoints: map["EXTRA_POINTS"],
        source: map["SRC"],
        size: await SizeFactory().get(map["SIZE"]));
    if (map["SUBRACE"] != null) {
      race.subrace = await SubraceFactory().create(map["SUBRACE"]);
    } else if (map["ID"] != null) {
      race.subrace = await getDefaultSubrace(map["ID"]);
    }
    return race;
  }

  @override
  Future<Map<String, dynamic>> toMap(Race object, [optimised = true]) async {
    Map<String, dynamic> map = {
      "ID": object.databaseId,
      "NAME": object.name,
      "EXTRA_POINTS": object.extraPoints,
      "SIZE": object.size.id,
      "SRC": object.source
    };
    if (optimised) {
      map = await optimise(map);
    }

    if (object.subrace != null && (object.databaseId == null || object.subrace != await getDefaultSubrace(map["ID"]))) {
      map["SUBRACE"] = await SubraceFactory().toMap(object.subrace!);
    } else {
      map.remove("SUBRACE");
    }
    return map;
  }
}

class SubraceFactory extends Factory<Subrace> {
  @override
  get tableName => 'subraces';

  @override
  Map<String, dynamic> get defaultValues => {"RANDOM_TALENTS": 0, "SRC": "Custom", "DEF": 1};

  @override
  Subrace fromMap(Map<String, dynamic> map) {
    defaultValues.forEach((key, value) {
      map.putIfAbsent(key, () => value);
    });
    return Subrace(
        id: map["ID"],
        name: map["NAME"],
        randomTalents: map["RANDOM_TALENTS"],
        source: map["SRC"],
        defaultSubrace: map["DEF"] == 1);
  }

  @override
  Future<Map<String, dynamic>> toMap(Subrace object, [optimised = true]) async {
    Map<String, dynamic> map = {
      "ID": object.id,
      "NAME": object.name,
      "RANDOM_TALENTS": object.randomTalents,
      "SRC": object.source,
      "DEF": object.defaultSubrace ? 1 : 0
    };
    if (optimised) {
      map = await optimise(map);
    }
    return map;
  }
}
