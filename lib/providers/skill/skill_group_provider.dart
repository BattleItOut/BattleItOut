import 'package:battle_it_out/persistence/skill/skill_group.dart';
import 'package:battle_it_out/providers/skill/base_skill_provider.dart';
import 'package:battle_it_out/providers/skill/skill_provider.dart';
import 'package:battle_it_out/utils/factory.dart';
import 'package:get_it/get_it.dart';

class SkillGroupRepository extends Repository<SkillGroup> {
  @override
  get tableName => 'skill_groups';

  @override
  Future<void> init() async {
    if (ready) return;
    await GetIt.instance.get<SkillRepository>().init();
    await GetIt.instance.get<BaseSkillRepository>().init();
    await super.init();
  }

  @override
  Future<List<SkillGroup>> getAll({String? where, List<Object>? whereArgs}) async {
    SkillRepository skillRepository = GetIt.instance.get<SkillRepository>();
    BaseSkillRepository baseSkillRepository = GetIt.instance.get<BaseSkillRepository>();
    return [
      ...await super.getAll(where: where, whereArgs: whereArgs),
      ...baseSkillRepository.items.where((s) => s.grouped).map((s) => SkillGroup(
            name: "${s.name}_ANY",
            skills: [...skillRepository.items.where((s) => s.baseSkill.id == s.id)],
          ))
    ];
  }

  Future<List<SkillGroup>> getLinkedToAncestry(int? ancestryId) async {
    final List<Map<String, dynamic>> map = await database.rawQuery(
        "SELECT * FROM SUBRACE_SKILLS SS JOIN SKILLS_BASE SB ON (SS.BASE_SKILL_ID = SB.ID) WHERE SUBRACE_ID = ?",
        [ancestryId]);

    return [
      for (Map<String, dynamic> entry in map)
        SkillGroup(
          name: "${entry["NAME"]}_ANY",
          skills: await getAll(where: "ID = ?", whereArgs: [entry["BASE_SKILL_ID"]]),
        )
    ];
  }

  @override
  Future<SkillGroup> fromDatabase(Map<String, dynamic> map) async {
    return SkillGroup(
      id: map["ID"],
      name: map["NAME"],
      closed: map["CLOSED"] == 1,
      skills: [],
    );
  }

  @override
  Future<Map<String, dynamic>> toDatabase(SkillGroup object) async {
    return {"ID": object.id, "NAME": object.name, "CLOSED": object.closed ? 1 : 0};
  }
}
