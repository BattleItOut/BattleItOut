import 'package:battle_it_out/persistence/dao/serializer.dart';
import 'package:battle_it_out/persistence/entities/attribute.dart';
import 'package:battle_it_out/persistence/entities/skill.dart';

class SkillFactory extends Factory<Skill> {
  List<Attribute>? attributes;

  SkillFactory([this.attributes]);

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
  Future<Skill> fromMap(Map<String, dynamic> map) async {
    Skill skill = Skill(
        databaseId: map["ID"],
        name: map["NAME"],
        specialisation: map["SPECIALISATION"],
        advances: map["ADVANCES"] ?? 0,
        earning: map["EARNING"] ?? false,
        canAdvance: map["ADVANCABLE"] ?? false);
    if (map["BASE_SKILL_ID"] != null) {
      skill.baseSkill = await BaseSkillFactory(attributes).get(map["BASE_SKILL_ID"]);
    }
    return skill;
  }

  @override
  Future<Map<String, dynamic>> toMap(Skill object, [optimised = true]) async {
    Map<String, dynamic> map = {
      "ID": object.databaseId,
      "NAME": object.name,
      "SPECIALISATION": object.specialisation,
      "ADVANCES": object.advances,
      "EARNING": object.earning,
      "ADVANCABLE": object.canAdvance
    };
    if (optimised) {
      map = await optimise(map);
    }
    if (object.baseSkill != null &&
        (object.baseSkill!.databaseId == null ||
            object.baseSkill != await BaseSkillFactory().get(object.baseSkill!.databaseId!))) {
      map["BASE_SKILL"] = BaseSkillFactory().toMap(object.baseSkill!);
    }
    return map;
  }
}

class BaseSkillFactory extends Factory<BaseSkill> {
  List<Attribute>? attributes;

  BaseSkillFactory([this.attributes]);

  @override
  get tableName => 'skills_base';

  @override
  BaseSkill fromMap(Map<String, dynamic> map) {
    Attribute? attribute = attributes?.firstWhere((attribute) => attribute.databaseId == map["ATTRIBUTE_ID"]);
    return BaseSkill(
        databaseId: map["ID"],
        name: map["NAME"],
        advanced: map["ADVANCED"] == 1,
        grouped: map["GROUPED"] == 1,
        description: map["DESCRIPTION"],
        attribute: attribute);
  }

  @override
  Map<String, dynamic> toMap(BaseSkill object, [optimised = true]) {
    return {
      "ID": object.databaseId,
      "NAME": object.name,
      "DESCRIPTION": object.description,
      "ADVANCED": object.advanced ? 1 : 0,
      "GROUPED": object.grouped ? 1 : 0,
      "ATTRIBUTE_ID": object.attribute?.id
    };
  }
}
