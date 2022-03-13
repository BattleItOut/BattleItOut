import 'package:battle_it_out/persistence/dao/dao.dart';
import 'package:battle_it_out/persistence/entities/profession.dart';

class ProfessionDAO extends DAO<Profession> {
  @override
  get tableName => 'professions';

  @override
  Future<Profession> fromMap(Map<String, dynamic> map) async {
    return Profession(
        id: map["ID"],
        name: map["NAME"],
        level: map["LEVEL"],
        source: map["SOURCE"],
        career: await ProfessionCareerDAO().get(map["CAREER_ID"]));
  }
}

class ProfessionCareerDAO extends DAO<ProfessionCareer> {
  @override
  get tableName => 'profession_careers';

  @override
  fromMap(Map<String, dynamic> map) async {
    return ProfessionCareer(
        id: map["ID"],
        name: map["NAME"],
        source: map["SOURCE"],
        professionClass: await ProfessionClassDAO().get(map["CLASS_ID"]));
  }
}

class ProfessionClassDAO extends DAO<ProfessionClass> {
  @override
  get tableName => 'profession_classes';

  @override
  fromMap(Map<String, dynamic> map) async {
    return ProfessionClass(id: map["ID"], name: map["NAME"], source: map["SOURCE"]);
  }
}
