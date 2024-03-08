import 'package:battle_it_out/persistence/profession/profession_class.dart';
import 'package:battle_it_out/utils/factory.dart';

class ProfessionClassRepository extends Repository<ProfessionClass> {
  @override
  get tableName => 'profession_classes';

  @override
  Map<String, dynamic> get defaultValues => {"SOURCE": "Custom"};

  @override
  Future<ProfessionClass> fromDatabase(Map<String, dynamic> map) async {
    return ProfessionClass(id: map["ID"], name: map["NAME"], source: map["SOURCE"]);
  }

  @override
  Future<Map<String, dynamic>> toDatabase(ProfessionClass object) async {
    return {"ID": object.id, "NAME": object.name, "SOURCE": object.source};
  }
}
