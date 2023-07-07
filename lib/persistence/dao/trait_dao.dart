import 'package:battle_it_out/persistence/dao/serializer.dart';
import 'package:battle_it_out/persistence/entities/trait.dart';

class TraitFactory extends Factory<Trait> {
  @override
  get tableName => 'npc_traits';

  @override
  fromMap(Map<String, dynamic> map, [Map overrideMap = const {}]) {
    return Trait(id: map["ID"], name: map["NAME"], description: map["DESCRIPTION"]);
  }

  @override
  Map<String, dynamic> toMap(Trait object, [optimised = true]) {
    return {
      "ID": object.id,
      "NAME": object.name,
      "DESCRIPTION": object.description,
    };
  }
}
