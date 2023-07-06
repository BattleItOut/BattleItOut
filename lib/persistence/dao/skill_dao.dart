import 'package:battle_it_out/persistence/dao/serializer.dart';
import 'package:battle_it_out/persistence/entities/attribute.dart';
import 'package:battle_it_out/persistence/entities/skill.dart';

class SkillFactory extends Factory<Skill> {
  Map<int, Attribute>? attributes;

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
        id: map["ID"],
        name: map["NAME"],
        specialisation: map["SPECIALISATION"],
        advances: map["ADVANCES"] ?? 0,
        earning: map["EARNING"] ?? false,
        advancable: map["ADVANCABLE"] ?? false);
    if (map["BASE_SKILL_ID"] != null) {
      skill.baseSkillID = map["BASE_SKILL_ID"];
      skill.baseSkill = await BaseSkillFactory(attributes).get(map["BASE_SKILL_ID"]);
    } if (map["BASE_SKILL"] != null) {
      skill.baseSkillID = map["BASE_SKILL"]["ID"];
      skill.baseSkill = await BaseSkillFactory(attributes).create(map["BASE_SKILL"]);
    }
    return skill;
  }

  @override
  Future<Map<String, dynamic>> toMap(Skill object, [optimised = true]) async {
    Map<String, dynamic> map = {
      "ID": object.id,
      "NAME": object.name,
      "SPECIALISATION": object.specialisation,
      "ADVANCES": object.advances,
      "EARNING": object.earning,
      "ADVANCABLE": object.advancable
    };
    if (optimised) {
      map = await optimise(map);
    }
    if (object.baseSkill != null && (object.baseSkill!.id == null || object.baseSkill != await BaseSkillFactory().get(object.baseSkill!.id!))) {
      map["BASE_SKILL"] = BaseSkillFactory().toMap(object.baseSkill!);
    }
    return map;
  }
}

class BaseSkillFactory extends Factory<BaseSkill> {
  Map<int, Attribute>? attributes;

  BaseSkillFactory([this.attributes]);

  @override
  get tableName => 'skills_base';

  @override
  BaseSkill fromMap(Map<String, dynamic> map) {
    return BaseSkill(
        id: map["ID"],
        name: map["NAME"],
        advanced: map["ADVANCED"] == 1,
        grouped: map["GROUPED"] == 1,
        description: map["DESCRIPTION"],
        attribute: attributes?[map["ATTRIBUTE_ID"]]);
  }

  @override
  Map<String, dynamic> toMap(BaseSkill object, [optimised = true]) {
    return {
      "ID": object.id,
      "NAME": object.name,
      "DESCRIPTION": object.description,
      "ADVANCED": object.advanced ? 1 : 0,
      "GROUPED": object.grouped ? 1 : 0,
      "ATTRIBUTE_ID": object.attribute?.id
    };
  }
}
