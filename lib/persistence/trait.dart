import 'package:battle_it_out/utils/db_object.dart';
import 'package:battle_it_out/utils/factory.dart';

class Trait extends DBObject {
  String name;
  String description;

  Trait({super.id, required this.name, required this.description});

  @override
  String toString() {
    return "Trait ($id, $name)";
  }
}

class TraitFactory extends Factory<Trait> {
  @override
  get tableName => 'npc_traits';

  @override
  Future<Trait> fromDatabase(Map<String, dynamic> map) async {
    return Trait(id: map["ID"], name: map["NAME"], description: map["DESCRIPTION"]);
  }

  @override
  Future<Map<String, dynamic>> toDatabase(Trait object, {optimised = true, database = false}) async {
    return {
      "ID": object.id,
      "NAME": object.name,
      "DESCRIPTION": object.description,
    };
  }

  @override
  Future<Map<String, Object?>> toMap(Trait object, {optimised = true, database = false}) async {
    return {
      "ID": object.id,
      "NAME": object.name,
      "DESCRIPTION": object.description,
    };
  }
}
