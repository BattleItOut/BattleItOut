import 'package:battle_it_out/persistence/profession/profession_career.dart';
import 'package:battle_it_out/persistence/profession/profession_class.dart';
import 'package:battle_it_out/providers/profession/profession_class_provider.dart';
import 'package:battle_it_out/utils/factory.dart';

class ProfessionCareerRepository extends Repository<ProfessionCareer> {
  @override
  get tableName => 'profession_careers';

  @override
  Map<String, dynamic> get defaultValues => {"SOURCE": "Custom"};

  Future<ProfessionClass> getClass(Map<String, dynamic> map) async {
    if (map["CLASS_ID"] != null) {
      return (await ProfessionClassRepository().get(map["CLASS_ID"]))!;
    } else if (map["CLASS"] != null) {
      return ProfessionClassRepository().create(map["CLASS"]);
    } else {
      return ProfessionClassRepository().create(map);
    }
  }

  @override
  Future<ProfessionCareer> fromMap(Map<String, dynamic> map) async {
    return ProfessionCareer(
        id: map["ID"], name: map["NAME"], source: map["SOURCE"], professionClass: (await getClass(map)));
  }

  @override
  Future<ProfessionCareer> fromDatabase(Map<String, dynamic> map) async {
    return ProfessionCareer(
        id: map["ID"],
        name: map["NAME"],
        source: map["SOURCE"],
        professionClass: (await ProfessionClassRepository().get(map["CLASS_ID"]))!);
  }

  @override
  Future<Map<String, dynamic>> toDatabase(ProfessionCareer object) async {
    return {"ID": object.id, "NAME": object.name, "SOURCE": object.source, "CLASS_ID": object.professionClass.id};
  }

  @override
  Future<Map<String, dynamic>> toMap(ProfessionCareer object, {optimised = true, database = false}) async {
    Map<String, dynamic> map = {
      "ID": object.id,
      "NAME": object.name,
      "SOURCE": object.source,
      "CLASS_ID": object.professionClass.id
    };
    if (optimised) {
      map = await optimise(map);
    }
    if (object.professionClass.id == null ||
        object.professionClass != await ProfessionClassRepository().get(object.professionClass.id!)) {
      map["CLASS"] = await ProfessionClassRepository().toMap(object.professionClass);
    }
    return map;
  }
}
