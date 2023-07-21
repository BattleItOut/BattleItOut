import 'package:battle_it_out/persistence/serializer.dart';

class ProfessionClass {
  int id;
  String name;
  String source;

  ProfessionClass._({required this.id, required this.name, required this.source});

  @override
  String toString() {
    return "ProfessionClass (id=$id, name=$name)";
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProfessionClass &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          source == other.source;

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ source.hashCode;
}

class ProfessionClassFactory extends Factory<ProfessionClass> {
  @override
  get tableName => 'profession_classes';

  @override
  Map<String, dynamic> get defaultValues => {"SOURCE": "Custom"};

  @override
  Future<ProfessionClass> fromMap(Map<String, dynamic> map) async {
    return ProfessionClass._(id: map["ID"] ?? await getNextId(), name: map["NAME"], source: map["SOURCE"]);
  }

  @override
  Future<Map<String, dynamic>> toMap(ProfessionClass object, {optimised = true, database = false}) async {
    Map<String, dynamic> map = {"ID": object.id, "NAME": object.name, "SOURCE": object.source};
    if (optimised) {
      map = await optimise(map);
    }
    return map;
  }
}
