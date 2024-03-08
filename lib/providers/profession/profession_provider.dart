import 'package:battle_it_out/persistence/profession/profession.dart';
import 'package:battle_it_out/persistence/profession/profession_career.dart';
import 'package:battle_it_out/providers/profession/profession_career_provider.dart';
import 'package:battle_it_out/providers/skill/skill_provider.dart';
import 'package:battle_it_out/providers/talent/talent_provider.dart';
import 'package:battle_it_out/utils/factory.dart';

class ProfessionRepository extends Repository<Profession> {
  @override
  get tableName => 'professions';

  @override
  Map<String, dynamic> get defaultValues => {"SOURCE": "Custom", "LEVEL": 1};

  Future<ProfessionCareer> getCareer(Map<String, dynamic> map) async {
    if (map["CAREER_ID"] != null) {
      return (await ProfessionCareerRepository().get(map["CAREER_ID"]))!;
    } else if (map["CAREER"] != null) {
      return ProfessionCareerRepository().create(map["CAREER"]);
    } else {
      return ProfessionCareerRepository().create(map);
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
    profession.linkedTalents = await TalentRepository().getLinkedToProfession(profession.id);
    profession.linkedSkills = await SkillRepository().getLinkedToProfession(profession.id);
    profession.linkedGroupSkills = await SkillRepository().getGroupsLinkedToProfession(profession.id);
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
    if (object.career.id == null || object.career != await ProfessionCareerRepository().get(object.career.id!)) {
      map["CAREER"] = await ProfessionCareerRepository().toMap(object.career);
    }
    return map;
  }
}
