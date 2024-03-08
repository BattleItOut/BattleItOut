import 'package:battle_it_out/persistence/talent/talent.dart';
import 'package:battle_it_out/persistence/talent/talent_test.dart';
import 'package:battle_it_out/providers/attribute_provider.dart';
import 'package:battle_it_out/providers/skill/base_skill_provider.dart';
import 'package:battle_it_out/providers/skill/skill_provider.dart';
import 'package:battle_it_out/utils/factory.dart';

class TalentTestRepository extends Repository<TalentTest> {
  Talent? talent;

  TalentTestRepository([this.talent]);

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
        baseSkill: map["BASE_SKILL_ID"] == null ? null : await BaseSkillRepository().get(map["BASE_SKILL_ID"]),
        skill: map["SKILL_ID"] == null ? null : await SkillRepository().get(map["SKILL_ID"]),
        attribute: map["ATTRIBUTE_ID"] == null ? null : await AttributeRepository().get(map["ATTRIBUTE_ID"]));
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
