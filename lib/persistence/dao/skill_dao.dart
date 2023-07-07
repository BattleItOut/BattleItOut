import 'package:battle_it_out/persistence/dao/dao.dart';
import 'package:battle_it_out/persistence/entities/attribute.dart';
import 'package:battle_it_out/persistence/entities/skill.dart';

class SkillDAO extends DAO<Skill> {
  Map<int, Attribute>? attributes;

  SkillDAO([this.attributes]);

  @override
  get tableName => 'skills';

  getSkills({bool? advanced}) async {
    List<Skill> skills = await getAll(where: "BASE_SKILL_ID IS NOT NULL");
    if (advanced != null) {
      skills = List.of(skills.where((skill) => skill.baseSkill!.advanced == advanced));
    }
    return skills;
  }

  @override
  Future<Skill> fromMap(Map<String, dynamic> map, [Map overrideMap = const {}]) async {
    BaseSkill? baseSkill = map["BASE_SKILL_ID"] == null ? null : await BaseSkillDAO(attributes).get(map["BASE_SKILL_ID"]);
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
        advanced: map["ADVANCED"] == 1,
        grouped: map["GROUPED"] == 1,
        description: map["DESCRIPTION"],
        attribute: attributes?[map["ATTRIBUTE_ID"]]);
  }
}
