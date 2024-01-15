import 'package:battle_it_out/utils/db_object.dart';
import 'package:battle_it_out/utils/factory.dart';

class Size extends DBObject {
  String name;
  String source;

  Size({super.id, required this.name, this.source = "Custom"});

  @override
  List<Object> get props => super.props..addAll([name, source]);
}

class SizeFactory extends Factory<Size> {
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
