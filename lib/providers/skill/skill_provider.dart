import 'package:battle_it_out/persistence/skill/skill.dart';
import 'package:battle_it_out/persistence/skill/skill_group.dart';
import 'package:battle_it_out/providers/skill/base_skill_provider.dart';
import 'package:battle_it_out/utils/factory.dart';
import 'package:get_it/get_it.dart';

class SkillRepository extends Repository<Skill> {
  @override
  get tableName => 'skills';

  @override
  Future<void> init() async {
    await GetIt.instance.get<BaseSkillRepository>().init();
    await super.init();
  }

  Future<List<Skill>> getSkills({bool? advanced}) async {
    List<Skill> skills = await getAll();
    if (advanced != null) {
      skills = List.of(skills.where((skill) => skill.baseSkill.advanced == advanced));
    }
    return skills;
  }

  Future<List<Skill>> getLinkedToAncestry(int? ancestryId) async {
    final List<Map<String, dynamic>> map = await database.rawQuery(
        "SELECT * FROM SUBRACE_SKILLS RS JOIN SKILLS S ON (S.ID = RS.SKILL_ID) WHERE SUBRACE_ID = ?", [ancestryId]);
    return [for (Map<String, dynamic> entry in map) await fromDatabase(entry)];
  }

  Future<List<Skill>> getLinkedToProfession(int? professionId) async {
    final List<Map<String, dynamic>> map = await database.rawQuery(
        "SELECT * FROM PROFESSION_SKILLS PS JOIN SKILLS S ON (PS.SKILL_ID = S.ID) WHERE PROFESSION_ID = ?",
        [professionId]);

    return [for (Map<String, dynamic> entry in map) await fromDatabase(entry)];
  }

  Future<List<SkillGroup>> getGroupsLinkedToProfession(int? professionId) async {
    List<Map<String, dynamic>> baseSkillsMap = await database.rawQuery(
        "SELECT * FROM PROFESSION_SKILLS PS JOIN SKILLS_BASE SB ON (PS.BASE_SKILL_ID = SB.ID) WHERE PROFESSION_ID = ?",
        [professionId]);

    List<SkillGroup> skillGroups = [
      for (Map<String, dynamic> entry in baseSkillsMap)
        SkillGroup(
          name: "${entry["NAME"]}_ANY",
          skills: await getMapAll(where: "ID = ?", whereArgs: [entry["BASE_SKILL_ID"]]),
        )
    ];

    List<Map<String, dynamic>> groupSkillsMap = await database.rawQuery(
        "SELECT * FROM PROFESSION_SKILLS PS JOIN SKILL_GROUPS SB ON (PS.SKILL_GROUP_ID = SB.ID) WHERE PROFESSION_ID = ?",
        [professionId]);
    for (Map<String, dynamic> entry in groupSkillsMap) {
      List<Map<String, dynamic>> skillsMap = await database.rawQuery(
          "SELECT * FROM SKILL_GROUPS_HIERARCHY SGH JOIN SKILLS S on S.ID = SGH.CHILD_ID WHERE PARENT_ID = ?",
          [entry["SKILL_GROUP_ID"] as int]);
      skillGroups.add(
        SkillGroup(
          name: entry["NAME"],
          skills: [for (Map<String, dynamic> skillEntry in skillsMap) await fromDatabase(skillEntry)],
        ),
      );
    }
    return skillGroups;
  }

  @override
  Future<Skill> fromDatabase(Map<String, dynamic> map) async {
    return Skill(
        id: map["ID"],
        name: map["NAME"],
        baseSkill: (await GetIt.instance.get<BaseSkillRepository>().get(map["BASE_SKILL_ID"]))!,
        specialisation: map["SPECIALISATION"],
        advances: map["ADVANCES"] ?? 0,
        earning: map["EARNING"] == 1,
        canAdvance: map["CAN_ADVANCE"] == 1);
  }

  @override
  Future<Map<String, dynamic>> toDatabase(Skill object) async {
    return {
      "ID": object.id,
      "NAME": object.name,
      "SPECIALISATION": object.specialisation,
    };
  }

  @override
  Future<Map<String, dynamic>> toMap(Skill object, {optimised = true, database = false}) async {
    Map<String, dynamic> map = {
      "ID": object.id,
      "NAME": object.name,
      "BASE_SKILL_ID": object.baseSkill.id,
      "SPECIALISATION": object.specialisation,
      "ADVANCES": object.advances,
      "EARNING": object.earning,
      "CAN_ADVANCE": object.canAdvance
    };
    if (optimised) {
      map = await optimise(map);
    }
    return map;
  }
}
