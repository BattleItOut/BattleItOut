import 'package:battle_it_out/persistence/dao/serializer.dart';
import 'package:battle_it_out/persistence/entities/weapon_length.dart';

class WeaponLengthFactory extends Factory<WeaponLength> {
  @override
  get tableName => 'weapon_lengths';

  @override
  fromMap(Map<String, dynamic> map, [Map overrideMap = const {}]) {
    return WeaponLength(id: map["ID"], name: map["NAME"], description: map["DESCRIPTION"], source: map["SOURCE"]);
  }

  @override
  Map<String, dynamic> toMap(WeaponLength object) {
    // TODO: implement toMap
    throw UnimplementedError();
  }
}
