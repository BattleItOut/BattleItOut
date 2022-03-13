import 'package:battle_it_out/persistence/dao/dao.dart';
import 'package:battle_it_out/persistence/entities/profession.dart';

class ProfessionDAO extends DAO<Profession> {
  @override
  get tableName => 'professions';

  @override
  Future<Profession> fromMap(Map<String, dynamic> map, [Map overrideMap = const {}]) async {
    return Profession(
        id: map["ID"],
        name: map["NAME"],
        nameEng: map["NAME_ENG"],
        level: map["LEVEL"],
        source: map["SRC"],
        career: await ProfessionCareerDAO().get(map["CAREER_ID"]));
  }
}

class ProfessionCareerDAO extends DAO<ProfessionCareer> {
  @override
  get tableName => 'profession_careers';

  @override
  Future<ProfessionCareer> fromMap(Map<String, dynamic> map, [Map overrideMap = const {}]) async {
    return ProfessionCareer(
        id: map["ID"], name: map["NAME"], professionClass: await ProfessionClassDAO().get(map["CLASS_ID"]));
  }
}

class ProfessionClassDAO extends DAO<ProfessionClass> {
  @override
  get tableName => 'profession_classes';

  @override
  ProfessionClass fromMap(Map<String, dynamic> map, [Map overrideMap = const {}]) {
    return ProfessionClass(id: map["ID"], name: map["NAME"]);
  }
}
