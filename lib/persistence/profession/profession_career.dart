import 'package:battle_it_out/persistence/profession/profession_class.dart';
import 'package:battle_it_out/utils/db_object.dart';
import 'package:battle_it_out/utils/factory.dart';

class ProfessionCareer extends DBObject {
  String name;
  String source;
  ProfessionClass professionClass;

  ProfessionCareer({super.id, required this.name, required this.professionClass, required this.source});

  @override
  String toString() {
    return "ProfessionCareer (id=$id, name=$name)";
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProfessionCareer &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          source == other.source &&
          professionClass == other.professionClass;

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ source.hashCode ^ professionClass.hashCode;
}

class ProfessionCareerFactory extends Factory<ProfessionCareer> {
  @override
  get tableName => 'profession_careers';

  @override
  Map<String, dynamic> get defaultValues => {"SOURCE": "Custom"};

  Future<ProfessionClass> getClass(Map<String, dynamic> map) async {
    if (map["CLASS_ID"] != null) {
      return ProfessionClassFactory().get(map["CLASS_ID"]);
    } else if (map["CLASS"] != null) {
      return ProfessionClassFactory().create(map["CLASS"]);
    } else {
      return ProfessionClassFactory().create(map);
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
        professionClass: await ProfessionClassFactory().get(map["CLASS_ID"]));
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
        object.professionClass != await ProfessionClassFactory().get(object.professionClass.id!)) {
      map["CLASS"] = await ProfessionClassFactory().toMap(object.professionClass);
    }
    return map;
  }
}
