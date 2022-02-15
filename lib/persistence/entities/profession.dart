import 'package:battle_it_out/persistence/dao/profession_dao.dart';
import 'package:battle_it_out/persistence/entities/attribute.dart';
import 'package:battle_it_out/persistence/entities/dto.dart';
import 'package:battle_it_out/persistence/entities/skill.dart';
import 'package:battle_it_out/persistence/wfrp_database.dart';

class Profession extends DTO {
  int id;
  String name;
  String nameEng;
  int level;
  String source;
  ProfessionCareer career;

  Map<int, Skill>? professionSkills;

  Profession(
      {required this.id,
      required this.name,
      required this.nameEng,
      required this.level,
      required this.source,
      required this.career});

  @override
  String toString() {
    return "Profession (id=$id, name=$name, lvl=$level)";
  }

  @override
  Map<String, dynamic> toMap() {
    return {"ID": id, "NAME": name, "NAME_ENG": nameEng, "LEVEL": level, "SRC": source, "CAREER_ID": career.id};
  }
}

class ProfessionCareer extends DTO {
  int id;
  String name;
  ProfessionClass professionClass;

  ProfessionCareer({required this.id, required this.name, required this.professionClass});

  @override
  String toString() {
    return "ProfessionCareer (id=$id, name=$name)";
  }

  @override
  Map<String, dynamic> toMap() {
    return {"ID": id, "NAME": name, "CLASS_ID": professionClass.id};
  }
}

class ProfessionClass extends DTO {
  int id;
  String name;

  ProfessionClass({required this.id, required this.name});

  @override
  String toString() {
    return "ProfessionClass (id=$id, name=$name)";
  }

  @override
  Map<String, dynamic> toMap() {
    return {"ID": id, "NAME": name};
  }
}
