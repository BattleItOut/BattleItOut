import 'package:battle_it_out/persistence/dao/serializer.dart';
import 'package:battle_it_out/persistence/entities/trait.dart';

class TraitFactory extends Factory<Trait> {
  @override
  get tableName => 'npc_traits';

  @override
  Future<Trait> fromMap(Map<String, dynamic> map) async {
    return Trait(id: map["ID"], name: map["NAME"], description: map["DESCRIPTION"]);
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
