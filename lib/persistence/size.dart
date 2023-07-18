import 'package:battle_it_out/persistence/serializer.dart';

class Size {
  int? id;
  String name;
  String source;

  Size._({this.id, required this.name, this.source = "Custom"});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Size &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          source == other.source;

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ source.hashCode;

  @override
  String toString() {
    return "Size ($id, $name)";
  }
}

class SizeFactory extends Factory<Size> {
  @override
  get tableName => 'sizes';

  @override
  Future<Size> fromMap(Map<String, dynamic> map) async {
    return Size._(id: map["ID"], name: map["NAME"], source: map["SOURCE"] ?? 'Custom');
  }

  @override
  Future<Map<String, dynamic>> toMap(Size object, {optimised = true, database = false}) async {
    return {"ID": object.id, "NAME": object.name, "SOURCE": object.source};
  }
}
