import 'package:battle_it_out/persistence/skill/skill_base.dart';
import 'package:battle_it_out/providers/attribute_provider.dart';
import 'package:battle_it_out/utils/factory.dart';
import 'package:get_it/get_it.dart';

class BaseSkillProvider extends Factory<BaseSkill> {
  @override
  get tableName => 'skills_base';

  @override
  Future<void> init() async {
    await GetIt.instance.get<AttributeProvider>().init();
    await super.init();
  }

  @override
  Future<BaseSkill> fromDatabase(Map<String, dynamic> map) async {
    return BaseSkill(
        id: map["ID"],
        name: map["NAME"],
        advanced: map["ADVANCED"] == 1,
        grouped: map["GROUPED"] == 1,
        description: map["DESCRIPTION"],
        attribute: (await GetIt.instance.get<AttributeProvider>().get(map["ATTRIBUTE_ID"]))!);
  }

  @override
  Future<Map<String, dynamic>> toDatabase(BaseSkill object) async {
    return {
      "ID": object.id,
      "NAME": object.name,
      "DESCRIPTION": object.description,
      "ADVANCED": object.advanced ? 1 : 0,
      "GROUPED": object.grouped ? 1 : 0,
      "ATTRIBUTE_ID": object.attribute.id
    };
  }

  @override
  Future<Map<String, dynamic>> toMap(BaseSkill object, {optimised = true, database = false}) async {
    return {
      "ID": object.id,
      "NAME": object.name,
      "DESCRIPTION": object.description,
      "ADVANCED": object.advanced ? 1 : 0,
      "GROUPED": object.grouped ? 1 : 0,
      "ATTRIBUTE_ID": object.attribute.id
    };
  }
}
