import 'package:battle_it_out/persistence/attribute.dart';
import 'package:battle_it_out/persistence/size.dart';
import 'package:battle_it_out/persistence/subrace.dart';
import 'package:battle_it_out/utils/db_object.dart';
import 'package:battle_it_out/utils/factory.dart';

class RacePartial extends DBObject {
  String? name;
  Size? size;
  String? source;

  RacePartial({super.id, this.name, this.size, this.source});

  Race toRace() {
    return Race(id: id, name: name!, size: size!, source: source!);
  }

  RacePartial.fromRace(Race? race) : this(id: race?.id, name: race?.name, size: race?.size, source: race?.source);

  @override
  List<Object?> get props => super.props..addAll([name, size, source]);

  bool compareTo(Race? race) {
    try {
      return toRace() == race;
    } on TypeError catch (_) {
      return false;
    }
  }
}

class Race extends DBObject {
  String name;
  Size size;
  String source;
  List<Subrace> ancestries = [];

  Race({super.id, required this.name, required this.size, this.source = "Custom"});

  static Race copy(Race race) {
    return Race(id: race.id, name: race.name, size: race.size, source: race.source);
  }

  @override
  List<Object?> get props => super.props..addAll([name, size, source]);
}

class RaceFactory extends Factory<Race> {
  @override
  get tableName => 'races';

  @override
  Map<String, dynamic> get defaultValues => {"EXTRA_POINTS": 0, "SRC": "Custom", "SIZE": 4};

  Future<List<Attribute>> getInitialAttributes(Race race) async {
    final List<Map<String, dynamic>> map = await database.rawQuery(
        "SELECT * FROM RACE_ATTRIBUTES RA JOIN ATTRIBUTES A ON (A.ID = RA.ATTR_ID) WHERE RACE_ID = ?", [race.id]);

    List<Attribute> attributes = [];
    for (Map<String, dynamic> entry in map) {
      Attribute attribute = await AttributeFactory().fromDatabase(entry);
      attribute.base = entry["VALUE"];
      attributes.add(attribute);
    }
    return attributes;
  }

  @override
  Future<int> delete(int id) async {
    await SubraceFactory().deleteWhere(where: "RACE_ID = ?", whereArgs: [id]);
    return super.delete(id);
  }

  @override
  Future<Race> fromDatabase(Map<String, dynamic> map) async {
    int id = map["ID"];
    return Race(id: id, name: map["NAME"], source: map["SRC"], size: await SizeFactory().get(map["SIZE"]));
  }

  @override
  Future<Race> fromMap(Map<String, dynamic> map) async {
    int id = map["ID"] ?? await getNextId();
    return Race(id: id, name: map["NAME"], source: map["SRC"], size: await SizeFactory().get(map["SIZE"]));
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
