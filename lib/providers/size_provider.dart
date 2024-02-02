import 'package:battle_it_out/persistence/size.dart';
import 'package:battle_it_out/utils/factory.dart';

class SizeProvider extends Factory<Size> {
  @override
  get tableName => 'sizes';

  @override
  Future<Size> fromDatabase(Map<String, dynamic> map) async {
    return Size(id: map["ID"], name: map["NAME"], source: map["SOURCE"] ?? 'Custom');
  }

  @override
  Future<Map<String, dynamic>> toDatabase(Size object) async {
    return {"ID": object.id, "NAME": object.name, "SOURCE": object.source};
  }

  @override
  Future<Map<String, Object?>> toMap(Size object, {optimised = true, database = false}) async {
    return {"ID": object.id, "NAME": object.name, "SOURCE": object.source};
  }
}
