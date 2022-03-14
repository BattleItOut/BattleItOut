import 'package:battle_it_out/persistence/dao/dao.dart';
import 'package:battle_it_out/persistence/entities/attribute.dart';
import 'package:battle_it_out/persistence/entities/skill.dart';

class SkillDAO extends DAO<Skill> {
  Map<int, Attribute> attributes;

  SkillDAO(this.attributes);

  @override
  get tableName => 'skills';

  getBasicSkills() async {
    List<Skill> basicSkills = await getAll(where: "IS_GROUP == ?", whereArgs: [0]);
    return basicSkills.where((skill) => skill.baseSkill.isAdvanced && skill.getSpecialityName() == null);
  }

  @override
  Future<Skill> fromMap(Map<String, dynamic> map, [Map overrideMap = const {}]) async {
    return Skill(
        id: map["ID"],
        name: map["NAME"],
        isGroup: map["IS_GROUP"] == 1,
        baseSkill: await BaseSkillDAO(attributes).get(map["BASE_SKILL"]));
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
