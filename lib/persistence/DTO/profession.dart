import 'package:battle_it_out/persistence/wfrp_database.dart';

class Profession {
  int id;
  String name;
  String nameEng;
  int level;
  String source;
  ProfessionCareer career;

  Profession({
    required this.id,
    required this.name,
    required this.nameEng,
    required this.level,
    required this.source,
    required this.career});

  static loadFromDatabase({required int id, required WFRPDatabase database}) async {
    Profession profession = await database.getProfession(id);
    return profession;
  }
}
class ProfessionCareer {
  int id;
  String name;
  ProfessionClass professionClass;

  ProfessionCareer({required this.id, required this.name, required this.professionClass});
}
class ProfessionClass {
  int id;
  String name;

  ProfessionClass({required this.id, required this.name});
}