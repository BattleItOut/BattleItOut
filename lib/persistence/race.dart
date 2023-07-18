import 'package:battle_it_out/persistence/serializer.dart';
import 'package:battle_it_out/persistence/size.dart';

class Race {
  int id;
  String name;
  Size size;
  int extraPoints;
  String source;

  Race._(
      {required this.id,
      required this.name,
      required this.size,
      required this.extraPoints,
      this.source = "Custom"});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Race &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          size == other.size &&
          extraPoints == other.extraPoints &&
          source == other.source;

  @override
  int get hashCode =>
      id.hashCode ^ name.hashCode ^ size.hashCode ^ extraPoints.hashCode ^ source.hashCode;

  @override
  String toString() {
    return 'Race{id: $id, name: $name, size: $size, extraPoints: $extraPoints, source: $source}';
  }
}

class RaceFactory extends Factory<Race> {
  @override
  get tableName => 'races';

  @override
  Map<String, dynamic> get defaultValues => {"EXTRA_POINTS": 0, "SRC": "Custom", "SIZE": 4};

  @override
  Future<Race> fromMap(Map<String, dynamic> map) async {
    Race race = Race._(
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
    return map;
  }
}
