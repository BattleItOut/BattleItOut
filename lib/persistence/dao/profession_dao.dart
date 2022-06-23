import 'package:battle_it_out/persistence/dao/serializer.dart';
import 'package:battle_it_out/persistence/entities/profession.dart';

class ProfessionFactory extends Factory<Profession> {
  @override
  get tableName => 'professions';

  @override
  Future<Profession> fromMap(Map<String, dynamic> map) async {
    Profession profession = Profession(
        id: map["ID"],
        name: map["NAME"],
        level: map["LEVEL"],
        source: map["SOURCE"] ?? 'Custom');
    if (map["CAREER_ID"] != null) {
      profession.career = await ProfessionCareerFactory().get(map["CAREER_ID"]);
    } else if (map["CAREER"] != null) {
      profession.career = await ProfessionCareerFactory().create(map["CAREER"]);
    }
    return profession;
  }

  @override
  Map<String, dynamic> toMap(Profession object) {
    Map<String, dynamic> map = {
      "ID": object.id,
      "NAME": object.name,
      "LEVEL": object.level,
      "SOURCE": object.source
    };
    if (object.career != null) {
      map["CAREER"] = ProfessionCareerFactory().toMap(object.career!);
    }
    return map;
  }
}

class ProfessionCareerFactory extends Factory<ProfessionCareer> {
  @override
  get tableName => 'profession_careers';

  @override
  Future<ProfessionCareer> fromMap(Map<String, dynamic> map, [Map overrideMap = const {}]) async {
    ProfessionCareer professionCareer = ProfessionCareer(
        id: map["ID"],
        name: map["NAME"],
        source: map["SOURCE"] ?? 'Custom');
    if (map["CLASS_ID"] != null) {
      professionCareer.professionClass = await ProfessionClassFactory().get(map["CLASS_ID"]);
    } else if (map["CLASS"] != null) {
      professionCareer.professionClass = await ProfessionClassFactory().create(map["CLASS"]);
    }
    return professionCareer;
  }

  @override
  Map<String, dynamic> toMap(ProfessionCareer object) {
    Map<String, dynamic> map = {
      "ID": object.id,
      "NAME": object.name,
      "SOURCE": object.source
    };
    if (object.professionClass != null) {
      map["CLASS"] = ProfessionClassFactory().toMap(object.professionClass!);
    }
    return map;
  }
}

class ProfessionClassFactory extends Factory<ProfessionClass> {
  @override
  get tableName => 'profession_classes';

  @override
  ProfessionClass fromMap(Map<String, dynamic> map, [Map overrideMap = const {}]) {
    return ProfessionClass(
        id: map["ID"],
        name: map["NAME"],
        source: map["SOURCE"] ?? 'Custom');
  }

  @override
  Map<String, dynamic> toMap(ProfessionClass object) {
    Map<String, dynamic> map = {
      "ID": object.id,
      "NAME": object.name,
      "SOURCE": object.source
    };
    return map;
  }
}
