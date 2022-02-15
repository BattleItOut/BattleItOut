import 'package:battle_it_out/persistence/dao/dao.dart';
import 'package:battle_it_out/persistence/entities/profession.dart';
import 'package:battle_it_out/persistence/wfrp_database.dart';

class ProfessionDAO extends Dao<Profession> {
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
        career: await database.getProfessionCareer(map["CAREER_ID"]));
  }

}

class ProfessionCareer {
  int id;
  String name;
  ProfessionClass professionClass;

  ProfessionCareer({required this.id, required this.name, required this.professionClass});

  @override
  String toString() {
    return "ProfessionCareer (id=$id, name=$name)";
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
