import 'package:battle_it_out/persistence/attribute.dart';
import 'package:battle_it_out/persistence/size.dart';
import 'package:battle_it_out/utils/db_object.dart';
import 'package:battle_it_out/utils/factory.dart';

class Race extends DBObject {
  String name;
  Size size;
  String source;
  List<Attribute> initialAttributes = [];

  Race(
      {super.id,
      required this.name,
      required this.size,
      this.source = "Custom",
      List<Attribute> initialAttributes = const []}) {
    this.initialAttributes.addAll(initialAttributes);
  }

  static Race copy(Race race) {
    return Race(
      id: race.id,
      name: race.name,
      size: race.size,
      source: race.source,
      initialAttributes: List.generate(
        race.initialAttributes.length,
        (index) => Attribute.copy(race.initialAttributes[index]),
      ),
    );
  }

  List<Attribute> getInitialAttributes() {
    return initialAttributes;
  }

  @override
  List<Object> get props => super.props..addAll([name, size, source, initialAttributes]);
}

class RaceFactory extends Factory<Race> {
  @override
  get tableName => 'races';

  @override
  Map<String, dynamic> get defaultValues => {"EXTRA_POINTS": 0, "SRC": "Custom", "SIZE": 4};

  Future<List<Attribute>> getInitialAttributes(int raceId) async {
    final List<Map<String, dynamic>> map = await database.rawQuery(
        "SELECT * FROM RACE_ATTRIBUTES RA JOIN ATTRIBUTES A ON (A.ID = RA.ATTR_ID) WHERE RACE_ID = ?", [raceId]);

    List<Attribute> attributes = [];
    for (Map<String, dynamic> entry in map) {
      Attribute attribute = await AttributeFactory().fromDatabase(entry);
      attribute.base = entry["VALUE"];
      attributes.add(attribute);
    }
    return attributes;
  }

  @override
  Future<Race> fromDatabase(Map<String, dynamic> map) async {
    int id = map["ID"];
    return Race(
        id: id,
        name: map["NAME"],
        source: map["SRC"],
        size: await SizeFactory().get(map["SIZE"]),
        initialAttributes: await getInitialAttributes(id));
  }

  @override
  Future<Race> fromMap(Map<String, dynamic> map) async {
    int id = map["ID"] ?? await getNextId();
    return Race(
        id: id,
        name: map["NAME"],
        source: map["SRC"],
        size: await SizeFactory().get(map["SIZE"]),
        initialAttributes: await getInitialAttributes(id));
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
