import 'package:battle_it_out/persistence/dao/serializer.dart';
import 'package:battle_it_out/persistence/entities/item/weapon_length.dart';

class WeaponLengthFactory extends Factory<WeaponLength> {
  @override
  get tableName => 'weapon_lengths';

  @override
  fromMap(Map<String, dynamic> map) {
    return WeaponLength(databaseId: map["ID"], name: map["NAME"], description: map["DESCRIPTION"], source: map["SOURCE"]);
  }

  @override
  Map<String, dynamic> toMap(WeaponLength object, [optimised = true]) {
    return {"ID": object.databaseId, "NAME": object.name, "DESCRIPTION": object.description, "SOURCE": object.source};
  }
}
