import 'package:battle_it_out/persistence/dao/serializer.dart';
import 'package:battle_it_out/persistence/entities/item/weapon_length.dart';

class WeaponLengthFactory extends Factory<WeaponLength> {
  @override
  get tableName => 'weapon_lengths';

  @override
  Future<WeaponLength> fromMap(Map<String, dynamic> map) async {
    return WeaponLength(id: map["ID"], name: map["NAME"], description: map["DESCRIPTION"], source: map["SOURCE"]);
  }

  @override
  Future<Map<String, dynamic>> toMap(WeaponLength object, {optimised = true, database = false}) async {
    return {"ID": object.id, "NAME": object.name, "DESCRIPTION": object.description, "SOURCE": object.source};
  }
}
