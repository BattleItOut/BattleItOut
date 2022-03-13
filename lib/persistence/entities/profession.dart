import 'package:battle_it_out/persistence/entities/dto.dart';
import 'package:battle_it_out/persistence/entities/skill.dart';

class Profession extends DTO {
  int? id;
  String name;
  int level;
  String source;
  ProfessionCareer? career;

  Map<int, Skill>? professionSkills;

  Profession(
      {this.id,
      required this.name,
      this.level = 1,
      this.source = "Custom",
      this.career});

  String getProperName() {
    if (career != null) {
      return "$name (${career!.name})";
    } else {
      return name;
    }
  }

  @override
  String toString() {
    return "Profession (id=$id, name=$name, lvl=$level)";
  }

  @override
  Map<String, dynamic> toMap() {
    return {"ID": id, "NAME": name, "LEVEL": level, "SOURCE": source, "CAREER_ID": career?.id};
  }
}

class ProfessionCareer extends DTO {
  int? id;
  String name;
  String source;
  ProfessionClass professionClass;

  ProfessionCareer({required this.id, required this.name, required this.professionClass, required this.source});

  @override
  String toString() {
    return "ProfessionCareer (id=$id, name=$name)";
  }

  @override
  Map<String, dynamic> toMap() {
    return {"ID": id, "NAME": name, "CLASS_ID": professionClass.id, "SOURCE": source};
  }
}

class ProfessionClass extends DTO {
  int id;
  String name;
  String source;

  ProfessionClass({required this.id, required this.name, required this.source});

  @override
  String toString() {
    return "ProfessionClass (id=$id, name=$name)";
  }

  @override
  Map<String, dynamic> toMap() {
    return {"ID": id, "NAME": name, "SOURCE": source};
  }
}
