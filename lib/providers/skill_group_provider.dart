import 'package:battle_it_out/persistence/skill/skill_group.dart';
import 'package:battle_it_out/providers/skill_base_provider.dart';
import 'package:battle_it_out/providers/skill_provider.dart';
import 'package:battle_it_out/utils/factory.dart';
import 'package:get_it/get_it.dart';

class SkillGroupProvider extends Factory<SkillGroup> {
  @override
  get tableName => 'skill_groups';

  @override
  Future<void> init() async {
    await GetIt.instance.get<SkillProvider>().init();
    await GetIt.instance.get<BaseSkillProvider>().init();
    await super.init();
  }

  @override
  Future<List<SkillGroup>> getAll({String? where, List<Object>? whereArgs}) async {
    SkillProvider skillProvider = GetIt.instance.get<SkillProvider>();
    BaseSkillProvider baseSkillProvider = GetIt.instance.get<BaseSkillProvider>();
    return [
      ...await super.getAll(where: where, whereArgs: whereArgs),
      ...baseSkillProvider.items.where((s) => s.grouped).map((s) => SkillGroup(
            name: "${s.name}_ANY",
            skills: [...skillProvider.items.where((s) => s.baseSkill.id == s.id)],
          ))
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
