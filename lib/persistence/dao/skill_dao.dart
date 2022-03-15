import 'package:battle_it_out/persistence/dao/dao.dart';
import 'package:battle_it_out/persistence/entities/attribute.dart';
import 'package:battle_it_out/persistence/entities/skill.dart';

class SkillDAO extends DAO<Skill> {
  Map<int, Attribute>? attributes;

  SkillDAO([this.attributes]);

  @override
  get tableName => 'skills';

  getBasicSkills() async {
    List<Skill> basicSkills = await getAll(where: "BASE_SKILL IS NOT NULL");
    return basicSkills.where((skill) => skill.baseSkill!.isAdvanced && skill.specialisation == null);
  }

  @override
  Future<Skill> fromMap(Map<String, dynamic> map, [Map overrideMap = const {}]) async {
    BaseSkill? baseSkill = map["BASE_SKILL"] == null ? null : await BaseSkillDAO(attributes).get(map["BASE_SKILL"]);
    return Skill(id: map["ID"], name: map["NAME"], specialisation: map["SPECIALISATION"], baseSkill: baseSkill);
  }
}

class BaseSkillDAO extends DAO<BaseSkill> {
  Map<int, Attribute>? attributes;

  BaseSkillDAO([this.attributes]);

  @override
  get tableName => 'skills_base';

  @override
  BaseSkill fromMap(Map<String, dynamic> map, [Map overrideMap = const {}]) {
    return BaseSkill(
        id: map["ID"],
        name: map["NAME"],
        isAdvanced: map["IS_ADVANCED"] == 1,
        description: map["DESCRIPTION"],
        attribute: attributes?[map["ATTRIBUTE_ID"]]);
  }
}
