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
        id: map["ID"],
        name: map["NAME"],
        specialisation: map["SPECIALISATION"],
        advances: map["ADVANCES"] ?? 0,
        earning: map["EARNING"] ?? false,
        canAdvance: map["CAN_ADVANCE"] ?? false);
    if (map["BASE_SKILL_ID"] != null) {
      skill.baseSkillID = map["BASE_SKILL_ID"];
      skill.baseSkill = await BaseSkillFactory(attributes).get(map["BASE_SKILL_ID"]);
    }
    return skill;
  }

  @override
  Future<Map<String, dynamic>> toMap(Skill object, {optimised = true, database = false}) async {
    Map<String, dynamic> map = {
      "ID": object.id,
      "NAME": object.name,
      "SPECIALISATION": object.specialisation,
      "ADVANCES": object.advances,
      "EARNING": object.earning,
      "CAN_ADVANCE": object.canAdvance
    };
    if (optimised) {
      map = await optimise(map);
    }
    if (object.baseSkill != null &&
        (object.baseSkill!.id == null || object.baseSkill != await BaseSkillFactory().get(object.baseSkill!.id!))) {
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
  Future<BaseSkill> fromMap(Map<String, dynamic> map) async {
    Attribute? attribute = attributes?.firstWhere((attribute) => attribute.id == map["ATTRIBUTE_ID"]);
    return BaseSkill(
        id: map["ID"],
        name: map["NAME"],
        advanced: map["ADVANCED"] == 1,
        grouped: map["GROUPED"] == 1,
        description: map["DESCRIPTION"],
        attribute: attribute);
  }

  @override
  Future<Map<String, dynamic>> toMap(BaseSkill object, {optimised = true, database = false}) async {
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
