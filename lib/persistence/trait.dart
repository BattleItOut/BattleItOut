import 'package:battle_it_out/persistence/serializer.dart';

class Trait {
  int id;
  String name;
  String description;

  Trait._({required this.id, required this.name, required this.description});

  @override
  String toString() {
    return "Trait ($id, $name)";
  }
}

class TraitFactory extends Factory<Trait> {
  @override
  get tableName => 'npc_traits';

  @override
  Future<Trait> fromMap(Map<String, dynamic> map) async {
    return Trait._(id: map["ID"], name: map["NAME"], description: map["DESCRIPTION"]);
  }

  @override
  Future<Map<String, dynamic>> toMap(Trait object, {optimised = true, database = false}) async {
    return {
      "ID": object.id,
      "NAME": object.name,
      "DESCRIPTION": object.description,
    };
  }
}
