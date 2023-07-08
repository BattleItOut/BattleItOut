import 'package:battle_it_out/persistence/dao/serializer.dart';
import 'package:battle_it_out/persistence/entities/profession.dart';

class ProfessionFactory extends Factory<Profession> {
  @override
  get tableName => 'professions';

  @override
  Map<String, dynamic> get defaultValues => {"SOURCE": "Custom"};

  @override
  Future<Profession> fromMap(Map<String, dynamic> map) async {
    defaultValues.forEach((key, value) {
      map.putIfAbsent(key, () => value);
    });
    Profession profession = Profession(
        id: map["ID"],
        name: map["NAME"],
        level: map["LEVEL"],
        source: map["SOURCE"]);
    if (map["CAREER_ID"] != null) {
      profession.career = await ProfessionCareerFactory().get(map["CAREER_ID"]);
    } else if (map["CAREER"] != null) {
      profession.career = await ProfessionCareerFactory().create(map["CAREER"]);
    }
    return profession;
  }

  @override
  Future<Map<String, dynamic>> toMap(Profession object,
      [optimised = true]) async {
    Map<String, dynamic> map = {
      "ID": object.id,
      "NAME": object.name,
      "LEVEL": object.level,
      "SOURCE": object.source
    };
    if (optimised) {
      map = await optimise(map);
    }
    if (object.career != null &&
        (object.career!.id == null ||
            object.career !=
                await ProfessionCareerFactory().get(object.career!.id!))) {
      map["CAREER"] = await ProfessionCareerFactory().toMap(object.career!);
    }
    return map;
  }
}

class ProfessionCareerFactory extends Factory<ProfessionCareer> {
  @override
  get tableName => 'profession_careers';

  @override
  Map<String, dynamic> get defaultValues => {"SOURCE": "Custom"};

  @override
  Future<ProfessionCareer> fromMap(Map<String, dynamic> map) async {
    defaultValues.forEach((key, value) {
      map.putIfAbsent(key, () => value);
    });
    ProfessionCareer professionCareer = ProfessionCareer(
        id: map["ID"], name: map["NAME"], source: map["SOURCE"]);
    if (map["CLASS_ID"] != null) {
      professionCareer.professionClass =
          await ProfessionClassFactory().get(map["CLASS_ID"]);
    } else if (map["CLASS"] != null) {
      professionCareer.professionClass =
          await ProfessionClassFactory().create(map["CLASS"]);
    }
    return professionCareer;
  }

  @override
  Future<Map<String, dynamic>> toMap(ProfessionCareer object,
      [optimised = true]) async {
    Map<String, dynamic> map = {
      "ID": object.id,
      "NAME": object.name,
      "SOURCE": object.source
    };
    if (optimised) {
      map = await optimise(map);
    }
    if (object.professionClass != null &&
        (object.professionClass!.id == null ||
            object.professionClass !=
                await ProfessionClassFactory()
                    .get(object.professionClass!.id!))) {
      map["CLASS"] =
          await ProfessionClassFactory().toMap(object.professionClass!);
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
  ProfessionClass fromMap(Map<String, dynamic> map) {
    defaultValues.forEach((key, value) {
      map.putIfAbsent(key, () => value);
    });
    return ProfessionClass(
        id: map["ID"], name: map["NAME"], source: map["SOURCE"]);
  }

  @override
  Future<Map<String, dynamic>> toMap(ProfessionClass object,
      [optimised = true]) async {
    Map<String, dynamic> map = {
      "ID": object.id,
      "NAME": object.name,
      "SOURCE": object.source
    };
    if (optimised) {
      map = await optimise(map);
    }
    return map;
  }
}
