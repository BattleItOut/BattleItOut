import 'package:battle_it_out/wfrp_database.dart';

class Profession {
  int id;
  String name;
  String nameEng;
  int level;
  String source;
  // int career;

  Profession({
    required this.id,
    required this.name,
    required this.nameEng,
    required this.level,
    required this.source});

  static create({required int id, required WFRPDatabase database}) async {
    Profession profession = await database.getProfession(id);
    return profession;
  }
  static fromMap(Map<String, dynamic> map) {
    return Profession(
        id: map["PROFESSION_ID"],
        name: map["NAME"],
        nameEng: map["NAME_ENG"],
        level: map["LEVEL"],
        source: map["SRC"]);
  }
}