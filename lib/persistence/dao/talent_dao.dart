import 'package:battle_it_out/persistence/dao/attribute_dao.dart';
import 'package:battle_it_out/persistence/dao/dao.dart';
import 'package:battle_it_out/persistence/dao/skill_dao.dart';
import 'package:battle_it_out/persistence/entities/attribute.dart';
import 'package:battle_it_out/persistence/entities/skill.dart';
import 'package:battle_it_out/persistence/entities/talent.dart';

class TalentDAO extends DAO<Talent> {
  Map<int, Attribute>? attributes;
  Map<int, Skill>? skills;

  TalentDAO([this.attributes, this.skills]);

  @override
  get tableName => 'talents';

  getAllTalents() async {
    List<Talent> talents = await getAll(where: "BASE_TALENT IS NOT NULL");
    return talents;
  }

  @override
  Future<Talent> fromMap(Map<String, dynamic> map, [Map overrideMap = const {}]) async {
    Talent talent = Talent(
        id: map['ID'],
        name: map['NAME'],
        specialisation: map["SPECIALISATION"],
        baseTalent: map["BASE_TALENT"] == null ? null : await BaseTalentDAO(attributes).get(map["BASE_TALENT"]));
    talent.tests = await TalentTestDAO(talent).getAllByTalent(map["ID"]);
    return talent;
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
  Talent? talent;

  TalentTestDAO([this.talent]);

  @override
  get tableName => 'talent_tests';

  Future<List<TalentTest>> getAllByTalent(int talentId) {
    return getAll(where: "TALENT_ID == ?", whereArgs: [talentId]);
  }

  @override
  Future<TalentTest> fromMap(Map<String, dynamic> map, [Map overrideMap = const {}]) async {
    return TalentTest(
        testID: map['TEST_ID'],
        talent: talent,
        comment: map["COMMENT"],
        baseSkill: map["BASE_SKILL_ID"] == null ? null : await BaseSkillDAO().get(map["BASE_SKILL_ID"]),
        skill: map["SKILL_ID"] == null ? null : await SkillDAO().get(map["SKILL_ID"]),
        attribute: map["ATTRIBUTE_ID"] == null ? null : await AttributeDAO().get(map["ATTRIBUTE_ID"]));
  }
}
