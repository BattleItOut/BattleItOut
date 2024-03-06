import 'package:battle_it_out/persistence/attribute.dart';
import 'package:battle_it_out/persistence/skill/skill.dart';
import 'package:battle_it_out/persistence/skill/skill_base.dart';
import 'package:battle_it_out/persistence/talent/talent.dart';
import 'package:battle_it_out/providers/attribute_provider.dart';
import 'package:battle_it_out/providers/skill_base_provider.dart';
import 'package:battle_it_out/providers/skill_provider.dart';
import 'package:battle_it_out/utils/db_object.dart';
import 'package:battle_it_out/utils/factory.dart';

class TalentTest extends DBObject {
  Talent? talent;
  String? comment;

  BaseSkill? baseSkill;
  Skill? skill;
  Attribute? attribute;

  TalentTest({super.id, required this.talent, this.comment, this.baseSkill, this.skill, this.attribute});

  @override
  String toString() {
    return "Test (id=$id, name=$comment, attribute=$attribute, baseSkill=$baseSkill, skill=$skill)";
  }
}

class TalentTestFactory extends Factory<TalentTest> {
  Talent? talent;

  TalentTestFactory([this.talent]);

  @override
  get tableName => 'talent_tests';

  Future<List<TalentTest>> getAllByTalent(int talentId) {
    return getAll(where: "TALENT_ID = ?", whereArgs: [talentId]);
  }

  @override
  Future<TalentTest> fromDatabase(Map<String, dynamic> map) async {
    return TalentTest(
        id: map['ID'],
        talent: talent,
        comment: map["COMMENT"],
        baseSkill: map["BASE_SKILL_ID"] == null ? null : await BaseSkillProvider().get(map["BASE_SKILL_ID"]),
        skill: map["SKILL_ID"] == null ? null : await SkillProvider().get(map["SKILL_ID"]),
        attribute: map["ATTRIBUTE_ID"] == null ? null : await AttributeProvider().get(map["ATTRIBUTE_ID"]));
  }

  @override
  Future<Map<String, dynamic>> toDatabase(TalentTest object) async {
    return {
      "ID": object.id,
      "TALENT_ID": object.talent!.id,
      "COMMENT": object.comment,
      "BASE_SKILL_ID": object.baseSkill?.id,
      "SKILL_ID": object.skill!.id,
      "ATTRIBUTE_ID": object.attribute!.id
    };
  }

  @override
  Future<Map<String, dynamic>> toMap(TalentTest object, {optimised = true, database = false}) async {
    return {
      "ID": object.id,
      "TALENT_ID": object.talent!.id,
      "COMMENT": object.comment,
      "BASE_SKILL_ID": object.baseSkill?.id,
      "SKILL_ID": object.skill!.id,
      "ATTRIBUTE_ID": object.attribute!.id
    };
  }
}
