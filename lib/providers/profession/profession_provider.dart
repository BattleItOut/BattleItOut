import 'package:battle_it_out/persistence/profession/profession.dart';
import 'package:battle_it_out/persistence/profession/profession_career.dart';
import 'package:battle_it_out/providers/profession/profession_career_provider.dart';
import 'package:battle_it_out/providers/skill/skill_provider.dart';
import 'package:battle_it_out/providers/talent/talent_provider.dart';
import 'package:battle_it_out/utils/factory.dart';
import 'package:get_it/get_it.dart';

class ProfessionRepository extends Repository<Profession> {
  @override
  get tableName => 'professions';

  @override
  Map<String, dynamic> get defaultValues => {"SOURCE": "Custom", "LEVEL": 1};

  @override
  Future<void> init() async {
    await GetIt.instance.get<ProfessionCareerRepository>().init();
    await super.init();
  }

  Future<ProfessionCareer> getCareer(Map<String, dynamic> map) async {
    if (map["CAREER_ID"] != null) {
      return (await GetIt.instance.get<ProfessionCareerRepository>().get(map["CAREER_ID"]))!;
    } else if (map["CAREER"] != null) {
      return GetIt.instance.get<ProfessionCareerRepository>().create(map["CAREER"]);
    } else {
      return GetIt.instance.get<ProfessionCareerRepository>().create(map);
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
    profession.linkedTalents = await GetIt.instance.get<TalentRepository>().getLinkedToProfession(profession.id);
    profession.linkedSkills = await GetIt.instance.get<SkillRepository>().getLinkedToProfession(profession.id);
    profession.linkedGroupSkills =
        await GetIt.instance.get<SkillRepository>().getGroupsLinkedToProfession(profession.id);
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
    if (object.career.id == null ||
        object.career != await GetIt.instance.get<ProfessionCareerRepository>().get(object.career.id!)) {
      map["CAREER"] = await GetIt.instance.get<ProfessionCareerRepository>().toMap(object.career);
    }
    return map;
  }
}
