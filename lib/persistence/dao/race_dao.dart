import 'package:battle_it_out/persistence/dao/serializer.dart';
import 'package:battle_it_out/persistence/dao/size_dao.dart';
import 'package:battle_it_out/persistence/entities/race.dart';

class SubraceFactory extends Factory<Subrace> {
  @override
  get tableName => 'subraces';

  @override
  Map<String, dynamic> get defaultValues => {
    "RANDOM_TALENTS": 0,
    "SRC": "Custom",
    "DEF": 1
  };

  Future<Race> getRace(Map<String, dynamic> map) async {
    if (map["RACE_ID"] != null) {
      return RaceFactory().get(map["RACE_ID"]);
    } else if (map["RACE"] != null) {
      return RaceFactory().create(map["RACE"]);
    } else {
      return RaceFactory().create(map);
    }
  }

  @override
  Future<Subrace> fromMap(Map<String, dynamic> map) async {
    return Subrace(
        id: map["ID"] ?? await getNextId(),
        race: await getRace(map),
        name: map["NAME"],
        randomTalents: map["RANDOM_TALENTS"],
        source: map["SRC"],
        defaultSubrace: map["DEF"] == 1);
  }

  @override
  Future<Map<String, dynamic>> toMap(Subrace object, {optimised = true, database = false}) async {
    Map<String, dynamic> map = {
      "ID": object.id,
      "RACE_ID": object.race.id,
      "NAME": object.name,
      "RANDOM_TALENTS": object.randomTalents,
      "SRC": object.source,
      "DEF": object.defaultSubrace ? 1 : 0
    };
    // if (optimised) {
    //   map = await optimise(map);
    // }
    return map;
  }
}

class RaceFactory extends Factory<Race> {
  @override
  get tableName => 'races';

  @override
  Map<String, dynamic> get defaultValues => {"EXTRA_POINTS": 0, "SRC": "Custom", "SIZE": 4};

  @override
  Future<Race> fromMap(Map<String, dynamic> map) async {
    Race race = Race(
        id: map["ID"] ?? await getNextId(),
        name: map["NAME"],
        extraPoints: map["EXTRA_POINTS"],
        source: map["SRC"],
        size: await SizeFactory().get(map["SIZE"]));
    return race;
  }

  @override
  Future<Map<String, dynamic>> toMap(Race object, {optimised = true, database = false}) async {
    Map<String, dynamic> map = {
      "ID": object.id,
      "NAME": object.name,
      "EXTRA_POINTS": object.extraPoints,
      "SIZE": object.size.id,
      "SRC": object.source
    };
    if (optimised) {
      map = await optimise(map);
    }

    // if (object.subrace != null && (object.subrace != await getDefaultSubrace(map["ID"]))) {
    //   map["SUBRACE"] = await SubraceFactory().toMap(object.subrace!);
    // } else {
    //   map.remove("SUBRACE");
    // }
    return map;
  }
}
