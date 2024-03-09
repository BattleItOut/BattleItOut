import 'package:battle_it_out/persistence/race.dart';
import 'package:battle_it_out/providers/ancestry_provider.dart';
import 'package:battle_it_out/providers/size_provider.dart';
import 'package:battle_it_out/utils/factory.dart';
import 'package:get_it/get_it.dart';

class RaceRepository extends Repository<Race> {
  @override
  get tableName => 'races';

  @override
  Map<String, dynamic> get defaultValues => {"EXTRA_POINTS": 0, "SRC": "Custom", "SIZE": 4};

  @override
  Future<void> init() async {
    if (ready) return;
    await GetIt.instance.get<SizeRepository>().init();
    await super.init();
  }

  @override
  Future<int> delete(Race object) async {
    await GetIt.instance.get<AncestryRepository>().deleteWhere(where: "RACE_ID = ?", whereArgs: [object.id!]);
    return super.delete(object);
  }

  @override
  Future<Race> fromDatabase(Map<String, dynamic> map) async {
    return Race.fromData(
      id: map["ID"],
      name: map["NAME"],
      source: map["SRC"],
      size: (await GetIt.instance.get<SizeRepository>().get(map["SIZE"]))!,
    );
  }

  @override
  Future<Race> fromMap(Map<String, dynamic> map) async {
    return Race.fromData(
      id: map["ID"] ?? await getNextId(),
      name: map["NAME"],
      source: map["SRC"],
      size: (await GetIt.instance.get<SizeRepository>().get(map["SIZE"]))!,
    );
  }

  @override
  Future<Map<String, dynamic>> toDatabase(Race object) async {
    return {"ID": object.id, "NAME": object.name, "SIZE": object.size.id, "SRC": object.source};
  }

  @override
  Future<Map<String, dynamic>> toMap(Race object, {optimised = true, database = false}) async {
    Map<String, dynamic> map = {"ID": object.id, "NAME": object.name, "SIZE": object.size.id, "SRC": object.source};
    if (optimised) {
      map = await optimise(map);
    }
    return map;
  }
}
