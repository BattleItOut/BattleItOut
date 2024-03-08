import 'package:battle_it_out/persistence/trait.dart';
import 'package:battle_it_out/utils/factory.dart';

class TraitRepository extends Repository<Trait> {
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
