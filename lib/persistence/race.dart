import 'package:battle_it_out/persistence/attribute.dart';
import 'package:battle_it_out/persistence/serializer.dart';
import 'package:battle_it_out/persistence/size.dart';
import 'package:battle_it_out/utils/database_provider.dart';
import 'package:sqflite/sqflite.dart';

class Race {
  int id;
  String name;
  Size size;
  String source;
  List<Attribute> initialAttributes = [];

  Race._(
      {required this.id,
      required this.name,
      required this.size,
      this.source = "Custom",
      List<Attribute> initialAttributes = const []}) {
    this.initialAttributes.addAll(initialAttributes);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Race &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          size == other.size &&
          source == other.source;

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ size.hashCode ^ source.hashCode;

  @override
  String toString() {
    return 'Race{id: $id, name: $name, size: $size, source: $source}';
  }
}

class RaceFactory extends Factory<Race> {
  @override
  get tableName => 'races';

  @override
  Map<String, dynamic> get defaultValues => {"EXTRA_POINTS": 0, "SRC": "Custom", "SIZE": 4};

  Future<List<Attribute>> getInitialAttributes(int raceId) async {
    Database? database = await DatabaseProvider.instance.getDatabase();

    final List<Map<String, dynamic>> map = await database.rawQuery(
        "SELECT * FROM RACE_ATTRIBUTES RA JOIN ATTRIBUTES A ON (A.ID = RA.ATTR_ID) WHERE RACE_ID = ?", [raceId]);

    List<Attribute> attributes = [];
    for (Map<String, dynamic> entry in map) {
      Attribute attribute = await AttributeFactory().create(entry);
      attribute.base = entry["VALUE"];
      attributes.add(attribute);
    }
    return attributes;
  }

  @override
  Future<Race> fromMap(Map<String, dynamic> map) async {
    Race race = Race._(
      id: map["ID"] ?? await getNextId(),
      name: map["NAME"],
      source: map["SRC"],
      size: await SizeFactory().get(map["SIZE"]),
    );
    race.initialAttributes = await getInitialAttributes(race.id);
    return race;
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
