import 'package:battle_it_out/persistence/dao/dao.dart';
import 'package:battle_it_out/persistence/entities/profession.dart';
import 'package:battle_it_out/persistence/wfrp_database.dart';

class ProfessionDAO extends DAO<Profession> {
  @override
  get tableName => 'professions';

  @override
  Future<Profession> fromMap(Map<String, dynamic> map, WFRPDatabase database) async {
    return Profession(
        id: map["ID"],
        name: map["NAME"],
        nameEng: map["NAME_ENG"],
        level: map["LEVEL"],
        source: map["SRC"],
        career: await ProfessionCareerDAO().get(database, map["CAREER_ID"]));
  }
}

class ProfessionCareerDAO extends DAO<ProfessionCareer> {
  @override
  get tableName => 'profession_careers';

  @override
  fromMap(Map<String, dynamic> map, WFRPDatabase database) async {
    return ProfessionCareer(
        id: map["ID"], name: map["NAME"], professionClass: await database.getProfessionClass(map["CLASS_ID"]));
  }
}

class ProfessionClass {
  int id;
  String name;

  ProfessionClass({required this.id, required this.name});

  @override
  String toString() {
    return "ProfessionClass (id=$id, name=$name)";
  }
}
