import 'package:battle_it_out/persistence/dao/serializer.dart';
import 'package:battle_it_out/persistence/entities/size.dart';

class SizeFactory extends Factory<Size> {
  @override
  get tableName => 'sizes';

  @override
  fromMap(Map<String, dynamic> map) async {
    return Size(databaseId: map["ID"], name: map["NAME"], source: map["SOURCE"] ?? 'Custom');
  }

  @override
  Map<String, dynamic> toMap(Size object, [optimised = true]) {
    return {"ID": object.databaseId, "NAME": object.name, "SOURCE": object.source};
  }
}
