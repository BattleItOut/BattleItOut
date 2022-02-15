import 'package:battle_it_out/persistence/dao/dao.dart';
import 'package:battle_it_out/persistence/entities/race.dart';
import 'package:battle_it_out/persistence/wfrp_database.dart';
import 'package:sqflite/sqlite_api.dart';

class RaceDAO extends Dao<Race> {
  @override
  get tableName => 'races';

  @override
  Race fromMap(Map<String, dynamic> map, WFRPDatabase database) {
    return Race(
        id: map["ID"], name: map["NAME"], extraPoints: map["EXTRA_POINTS"], size: map["SIZE"], source: map["SRC"]);
  }
}

class SubraceDAO extends Dao<Subrace> {
  @override
  get tableName => 'subraces';

  @override
  Subrace fromMap(Map<String, dynamic> map, WFRPDatabase database) {
    return Subrace(
        id: map["ID"],
        name: map["NAME"],
        source: map["SRC"],
        randomTalents: map["RANDOM_TALENTS"],
        defaultSubrace: map["DEF"] == 1);
  }
}
