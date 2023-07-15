import 'package:battle_it_out/persistence/dao/serializer.dart';
import 'package:battle_it_out/persistence/entities/profession.dart';

class ProfessionFactory extends Factory<Profession> {
  @override
  get tableName => 'professions';

  @override
  Map<String, dynamic> get defaultValues => {"SOURCE": "Custom", "LEVEL": 1};

  Future<ProfessionCareer> getCareer(Map<String, dynamic> map) async {
    if (map["CAREER_ID"] != null) {
      return ProfessionCareerFactory().get(map["CAREER_ID"]);
    } else if (map["CAREER"] != null) {
      return ProfessionCareerFactory().create(map["CAREER"]);
    } else {
      return ProfessionCareerFactory().create(map);
    }
  }

  @override
  Future<Profession> fromMap(Map<String, dynamic> map) async {
    return Profession(
      id: map["ID"] ?? await getNextId(),
      name: map["NAME"],
      level: map["LEVEL"],
      source: map["SOURCE"],
      career: await getCareer(map),
    );
  }

  @override
  Future<Map<String, dynamic>> toMap(Profession object, {optimised = true, database = false}) async {
    Map<String, dynamic> map = {
      "ID": object.id,
      "NAME": object.name,
      "LEVEL": object.level,
      "SOURCE": object.source,
      "CAREER_ID": object.career.id
    };
    if (optimised) {
      map = await optimise(map);
    }
    if ((object.career != await ProfessionCareerFactory().get(object.career.id))) {
      map["CAREER"] = await ProfessionCareerFactory().toMap(object.career);
    }
    return map;
  }
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
    ProfessionCareer professionCareer = ProfessionCareer(
        id: map["ID"] ?? await getNextId(),
        name: map["NAME"],
        source: map["SOURCE"],
        professionClass: await getClass(map));
    return professionCareer;
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
    if ((object.professionClass != await ProfessionClassFactory().get(object.professionClass.id))) {
      map["CLASS"] = await ProfessionClassFactory().toMap(object.professionClass);
    }
    return map;
  }
}

class ProfessionClassFactory extends Factory<ProfessionClass> {
  @override
  get tableName => 'profession_classes';

  @override
  Map<String, dynamic> get defaultValues => {"SOURCE": "Custom"};

  @override
  Future<ProfessionClass> fromMap(Map<String, dynamic> map) async {
    return ProfessionClass(id: map["ID"] ?? await getNextId(), name: map["NAME"], source: map["SOURCE"]);
  }

  @override
  Future<Map<String, dynamic>> toMap(ProfessionClass object, {optimised = true, database = false}) async {
    Map<String, dynamic> map = {"ID": object.id, "NAME": object.name, "SOURCE": object.source};
    if (optimised) {
      map = await optimise(map);
    }
    return map;
  }
}
