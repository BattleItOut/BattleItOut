import 'package:battle_it_out/persistence/profession/profession_career.dart';
import 'package:battle_it_out/persistence/skill/skill.dart';
import 'package:battle_it_out/persistence/skill/skill_group.dart';
import 'package:battle_it_out/persistence/talent/talent.dart';
import 'package:battle_it_out/persistence/talent/talent_group.dart';
import 'package:battle_it_out/utils/db_object.dart';
import 'package:battle_it_out/utils/factory.dart';

class Profession extends DBObject {
  String name;
  String source;
  int level;
  ProfessionCareer career;

  List<Skill> linkedSkills = [];
  List<SkillGroup> linkedGroupSkills = [];
  List<Talent> linkedTalents = [];
  List<TalentGroup> linkedGroupTalents = [];

  Profession({super.id, required this.name, required this.career, this.level = 1, this.source = "Custom"});

  @override
  String toString() {
    return "Profession (id=$id, name=$name, lvl=$level)";
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Profession &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          source == other.source &&
          level == other.level &&
          career == other.career;

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ source.hashCode ^ level.hashCode ^ career.hashCode;
}

class ProfessionFactory extends Factory<Profession> {
  @override
  get tableName => 'professions';

  @override
  Map<String, dynamic> get defaultValues => {"SOURCE": "Custom", "LEVEL": 1};

  Future<ProfessionCareer> getCareer(Map<String, dynamic> map) async {
    if (map["CAREER_ID"] != null) {
      return ProfessionCareerFactory().get(map["CAREER_ID"]);
    } else if (map["CAREER"] != null) {
      return ProfessionCareerFactory().create(map["CAREER"]);
    } else {
      return ProfessionCareerFactory().create(map);
    }
  }

  @override
  Future<Profession> fromDatabase(Map<String, dynamic> map) async {
    Profession profession = Profession(
      id: map["ID"],
      name: map["NAME"],
      level: map["LEVEL"],
      source: map["SOURCE"],
      career: await getCareer(map),
    );
    profession.linkedTalents = await TalentFactory().getLinkedToProfession(profession.id);
    profession.linkedSkills = await SkillFactory().getLinkedToProfession(profession.id);
    profession.linkedGroupSkills = await SkillFactory().getGroupsLinkedToProfession(profession.id);
    return profession;
  }

  @override
  Future<Map<String, dynamic>> toDatabase(Profession object) async {
    return {
      "ID": object.id,
      "NAME": object.name,
      "LEVEL": object.level,
      "SOURCE": object.source,
      "CAREER_ID": object.career.id
    };
  }

  @override
  Future<Map<String, dynamic>> toMap(Profession object, {optimised = true, database = false}) async {
    Map<String, dynamic> map = {
      "ID": object.id,
      "NAME": object.name,
      "LEVEL": object.level,
      "SOURCE": object.source,
      "CAREER_ID": object.career.id
    };
    if (optimised) {
      map = await optimise(map);
    }
    if (object.career.id == null || object.career != await ProfessionCareerFactory().get(object.career.id!)) {
      map["CAREER"] = await ProfessionCareerFactory().toMap(object.career);
    }
    return map;
  }
}
