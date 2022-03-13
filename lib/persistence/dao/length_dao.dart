import 'package:battle_it_out/persistence/dao/dao.dart';
import 'package:battle_it_out/persistence/entities/weapon_length.dart';

class WeaponLengthDao extends DAO<WeaponLength> {
  @override
  get tableName => 'weapon_lengths';

  @override
  fromMap(Map<String, dynamic> map, [Map overrideMap = const {}]) {
    return WeaponLength(id: map["ID"], name: map["NAME"], description: map["DESCRIPTION"], source: map["SOURCE"]);
  }
}
