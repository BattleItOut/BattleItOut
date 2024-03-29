import 'package:battle_it_out/utils/db_object.dart';
import 'package:battle_it_out/utils/factory.dart';

class WeaponLength extends DBObject {
  String name;
  String? description;
  String source;

  WeaponLength({super.id, required this.name, this.description, this.source = "Custom"});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WeaponLength &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          description == other.description &&
          source == other.source;

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ description.hashCode ^ source.hashCode;

  @override
  String toString() {
    return "WeaponLength ($id, $name)";
  }
}

class WeaponLengthFactory extends Factory<WeaponLength> {
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
