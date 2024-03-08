import 'package:battle_it_out/persistence/item/weapon_length.dart';
import 'package:battle_it_out/utils/factory.dart';

class WeaponLengthRepository extends Repository<WeaponLength> {
  @override
  get tableName => 'weapon_lengths';

  @override
  Future<WeaponLength> fromDatabase(Map<String, dynamic> map) async {
    return WeaponLength(id: map["ID"], name: map["NAME"], description: map["DESCRIPTION"], source: map["SOURCE"]);
  }

  @override
  Future<Map<String, dynamic>> toDatabase(WeaponLength object) async {
    return {"ID": object.id, "NAME": object.name, "DESCRIPTION": object.description, "SOURCE": object.source};
  }
}
