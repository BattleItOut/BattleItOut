import 'package:battle_it_out/persistence/dao/dao.dart';
import 'package:battle_it_out/persistence/dao/skill_dao.dart';
import 'package:battle_it_out/persistence/entities/attribute.dart';
import 'package:battle_it_out/persistence/entities/talent.dart';

class TalentDAO extends DAO<Talent> {
  Map<int, Attribute>? attributes;

  TalentDAO([this.attributes]);

  @override
  get tableName => 'talents';

  @override
  Future<Talent> fromMap(Map<String, dynamic> map, [Map overrideMap = const {}]) async {
    BaseTalent? baseTalent =
        map["BASE_TALENT"] == null ? null : await BaseTalentDAO(attributes).get(map["BASE_TALENT"]);
    return Talent(id: map['ID'], name: map['NAME'], specialisation: map["SPECIALISATION"], baseTalent: baseTalent);
  }
}

class BaseTalentDAO extends DAO<BaseTalent> {
  Map<int, Attribute>? attributes;

  BaseTalentDAO([this.attributes]);

  @override
  get tableName => 'talents_base';

  @override
  BaseTalent fromMap(Map<String, dynamic> map, [Map overrideMap = const {}]) {
    return BaseTalent(
        id: map['ID'],
        name: map['NAME'],
        description: map['DESCRIPTION'],
        source: map['SOURCE'],
        attribute: attributes?[map["MAX_LVL"]],
        constLvl: map['CONST_LVL']);
  }
}

class TalentTestDAO extends DAO<TalentTest> {
  TalentTestDAO();

  @override
  get tableName => 'talent_tests';

  @override
  Future<TalentTest> fromMap(Map<String, dynamic> map, [Map overrideMap = const {}]) async {
    return TalentTest(
        talentId: map['TALENT_ID'],
        testId: map['TEST_ID'],
        description: map['DESCRIPTION'],
        baseSkill: await BaseSkillDAO().get(map['BASE_SKILL_ID']),
        skill: await SkillDAO().get(map['SKILL_ID']),
        comment: map["COMMENT"]);
  }
}
