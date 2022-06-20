import 'package:battle_it_out/persistence/dao/attribute_dao.dart';
import 'package:battle_it_out/persistence/dao/serializer.dart';
import 'package:battle_it_out/persistence/dao/skill_dao.dart';
import 'package:battle_it_out/persistence/entities/attribute.dart';
import 'package:battle_it_out/persistence/entities/skill.dart';
import 'package:battle_it_out/persistence/entities/talent.dart';

class TalentFactory extends Factory<Talent> {
  Map<int, Attribute>? attributes;
  Map<int, Skill>? skills;

  TalentFactory([this.attributes, this.skills]);

  @override
  get tableName => 'talents';

  getAllTalents() async {
    List<Talent> talents = await getAll(where: "BASE_TALENT_ID IS NOT NULL");
    return talents;
  }

  @override
  Future<Talent> fromMap(Map<String, dynamic> map) async {
    Talent talent = Talent(
        id: map['ID'],
        name: map['NAME'],
        specialisation: map["SPECIALISATION"],
        currentLvl: map["LVL"] ?? 0,
        advancable: map["ADVANCABLE"] ?? false);

    // Base talent
    if (map["BASE_TALENT_ID"] != null) {
      talent.baseTalent = await BaseTalentFactory(attributes).get(map["BASE_TALENT_ID"]);
    }

    // Tests
    talent.tests = await TalentTestFactory(talent).getAllByTalent(map["ID"]);
    if (map["TESTS"] != null) {
      talent.tests.addAll([for (map in map["TESTS"]) await TalentTestFactory(talent).create(map)]);
    }
    return talent;
  }

  @override
  Future<Map<String, dynamic>> toMap(Talent object, [optimised = true]) async {
    Map<String, dynamic> map = {
      "ID": object.id,
      "NAME": object.name,
      "SPECIALISATION": object.specialisation,
      "LVL": object.currentLvl,
      "ADVANCABLE": object.advancable
    };
    if (optimised) {
      map = await optimise(map);
    }
    if (object.baseTalent != null && object.baseTalent != await BaseTalentFactory().get(object.baseTalent!.id)) {
      map["BASE_TALENT"] = BaseTalentFactory().toMap(object.baseTalent!);
    }
    return map;
  }
}

class BaseTalentFactory extends Factory<BaseTalent> {
  Map<int, Attribute>? attributes;

  BaseTalentFactory([this.attributes]);

  @override
  get tableName => 'talents_base';

  @override
  BaseTalent fromMap(Map<String, dynamic> map) {
    return BaseTalent(
        id: map['ID'],
        name: map['NAME'],
        description: map['DESCRIPTION'],
        source: map['SOURCE'],
        attribute: attributes?[map["MAX_LVL"]],
        constLvl: map['CONST_LVL'],
        grouped: map["GROUPED"] == 1 ? true : false);
  }

  @override
  Map<String, dynamic> toMap(BaseTalent object, [optimised = true]) {
    return {
      "ID": object.id,
      "NAME": object.name,
      "DESCRIPTION": object.description,
      "SOURCE": object.source,
      "CONST_LVL": object.constLvl,
      "GROUPED": object.grouped ? 1 : 0
    };
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
  Future<TalentTest> fromMap(Map<String, dynamic> map) async {
    return TalentTest(
        id: map['ID'],
        talent: talent,
        comment: map["COMMENT"],
        baseSkill: map["BASE_SKILL_ID"] == null ? null : await BaseSkillFactory().get(map["BASE_SKILL_ID"]),
        skill: map["SKILL_ID"] == null ? null : await SkillFactory().get(map["SKILL_ID"]),
        attribute: map["ATTRIBUTE_ID"] == null ? null : await AttributeFactory().get(map["ATTRIBUTE_ID"]));
  }

  @override
  Map<String, dynamic> toMap(TalentTest object, [optimised = true]) {
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
