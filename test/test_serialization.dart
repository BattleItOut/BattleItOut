import 'package:battle_it_out/persistence/dao/attribute_dao.dart';
import 'package:battle_it_out/persistence/dao/profession_dao.dart';
import 'package:battle_it_out/persistence/dao/race_dao.dart';
import 'package:battle_it_out/persistence/dao/skill_dao.dart';
import 'package:battle_it_out/persistence/dao/talent_dao.dart';
import 'package:battle_it_out/persistence/entities/attribute.dart';
import 'package:battle_it_out/persistence/entities/profession.dart';
import 'package:battle_it_out/persistence/entities/race.dart';
import 'package:battle_it_out/persistence/entities/skill.dart';
import 'package:battle_it_out/persistence/entities/talent.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> serializationTest() async {
  await raceSerializationTest();
  await professionSerializationTest();
  await attributeSerializationTest();
  await skillSerializationTest();
  await talentSerializationTest();
}

void doubleSerializationTest(factory, list) {
  test("Serialize and deserialize", () async {
    for (var object1 in list) {
      Map<String, dynamic> map = factory.toMap(object1);
      var object2 = await factory.fromMap(map);
      expect(object1, object2);
    }
  });
}

Future<void> raceSerializationTest() async {
  Race basicRace = await RaceFactory().create({"ID": 1});
  Race minCustomRace = await RaceFactory().create({
    "NAME": "Test",
    "SIZE": 4
  });
  Race maxCustomRace = await RaceFactory().create({
    "NAME": "Test",
    "SIZE": 4,
    "EXTRA_POINTS": 4,
    "SUBRACE": {
      "NAME": "Test2",
      "RANDOM_TALENTS": 3
    }
  });

  group("Race", () {
    test("Basic from database", () {
      expect(basicRace.id, 1);
      expect(basicRace.name, "HUMAN");
      expect(basicRace.size.id, 4);
      expect(basicRace.extraPoints, 3);
      expect(basicRace.source, "Main Rulebook");
      expect(basicRace.subrace!.id, 1);
      expect(basicRace.subrace!.name, "REIKLANDER");
    });
    test("Minimal custom", () {
      expect(minCustomRace.id, null);
      expect(minCustomRace.name, "Test");
      expect(minCustomRace.size.id, 4);
      expect(minCustomRace.extraPoints, 0);
      expect(minCustomRace.source, "Custom");
      expect(minCustomRace.subrace, null);
    });
    test("Maximal custom", () {
      expect(maxCustomRace.id, null);
      expect(maxCustomRace.name, "Test");
      expect(maxCustomRace.size.id, 4);
      expect(maxCustomRace.extraPoints, 4);
      expect(maxCustomRace.source, "Custom");
      expect(maxCustomRace.subrace!.name, "Test2");
      expect(maxCustomRace.subrace!.randomTalents, 3);
    });
    doubleSerializationTest(RaceFactory(), [basicRace, minCustomRace, maxCustomRace]);
  });
}
Future<void> professionSerializationTest() async {
  Profession basicProfession = await ProfessionFactory().create({"ID": 1});
  Profession minCustomProfession = await ProfessionFactory().create({
    "NAME": "Test"
  });
  Profession maxCustomProfession = await ProfessionFactory().create({
    "NAME": "Test",
    "LEVEL": 1,
    "CAREER": {
      "NAME": "Test2",
      "CLASS": {
        "NAME": "Test3"
      }
    }
  });

  group("Profession", () {
    test("Basic from database", () {
      expect(basicProfession.id, 1);
      expect(basicProfession.name, "APOTHECARY_1");
      expect(basicProfession.source, "Main Rulebook");
      expect(basicProfession.level!, 1);
      expect(basicProfession.career!.id, 1);
      expect(basicProfession.career!.name, "APOTHECARY_2");
      expect(basicProfession.career!.source, "Main Rulebook");
      expect(basicProfession.career!.professionClass!.id, 1);
      expect(basicProfession.career!.professionClass!.name, "ACADEMIC");
      expect(basicProfession.career!.professionClass!.source, "Main Rulebook");
    });
    test("Minimal custom", () {
      expect(minCustomProfession.id, null);
      expect(minCustomProfession.name, "Test");
      expect(minCustomProfession.source, "Custom");
      expect(minCustomProfession.career, null);
    });
    test("Maximal custom", () {
      expect(maxCustomProfession.id, null);
      expect(maxCustomProfession.name, "Test");
      expect(maxCustomProfession.source, "Custom");
      expect(maxCustomProfession.career!.name, "Test2");
      expect(maxCustomProfession.career!.source, "Custom");
      expect(maxCustomProfession.career!.professionClass!.name, "Test3");
      expect(maxCustomProfession.career!.professionClass!.source, "Custom");
    });
    doubleSerializationTest(ProfessionFactory(), [basicProfession, minCustomProfession, maxCustomProfession]);
  });
}
Future<void> attributeSerializationTest() async {
  Attribute basicAttribute = await AttributeFactory().create({"ID": 1});

  group("Attribute", () {
    test("Basic from database", () {
      expect(basicAttribute.id, 1);
      expect(basicAttribute.name, "WEAPON_SKILL");
      expect(basicAttribute.shortName, "WEAPON_SKILL_SHORT");
      expect(basicAttribute.description, "WEAPON_SKILL_DESC");
      expect(basicAttribute.rollable, 1);
      expect(basicAttribute.importance, 0);
      expect(basicAttribute.base, 0);
      expect(basicAttribute.advances, 0);
    });
    doubleSerializationTest(AttributeFactory(), [basicAttribute]);
  });
}
Future<void> skillSerializationTest() async {
  Skill basicSkill = await SkillFactory().create({"ID": 1});
  Skill minCustomSkill = await SkillFactory().create({
    "ID": 1,
    "NAME": "Test"
  });
  Skill maxCustomSkill = await SkillFactory().create({
    "ID": 1,
    "NAME": "Test",
    "SPECIALISATION": "Test2",
    "BASE_SKILL": {
      "ID": 1,
      "NAME": "Test3",
      "DESCRIPTION": "Test4",
      "ADVANCED": 0,
      "GROUPED": 0,
      "ATTRIBUTE_ID": 1
    },
    "ADVANCES": 2,
    "ADVANCABLE": true
  });

  group("Skills", () {
    test("Basic from database", () {
      expect(basicSkill.id, 1);
      expect(basicSkill.name, "ATHLETICS");
      expect(basicSkill.specialisation, null);
      expect(basicSkill.baseSkill!.id, 1);
      expect(basicSkill.baseSkill!.name, "ATHLETICS");
      expect(basicSkill.baseSkill!.description, "ATHLETICS_DESC");
      expect(basicSkill.baseSkill!.advanced, false);
      expect(basicSkill.baseSkill!.grouped, false);
    });
    test("Minimal custom", () {
      expect(minCustomSkill.id, 1);
      expect(minCustomSkill.name, "Test");
    });
    test("Maximal custom", () {
      expect(maxCustomSkill.id, 1);
      expect(maxCustomSkill.name, "Test");
      expect(maxCustomSkill.specialisation, "Test2");
      expect(maxCustomSkill.baseSkill!.name, "Test3");
      expect(maxCustomSkill.baseSkill!.description, "Test4");
      expect(maxCustomSkill.baseSkill!.advanced, false);
      expect(maxCustomSkill.baseSkill!.grouped, false);
    });
    doubleSerializationTest(SkillFactory(), [basicSkill, minCustomSkill, maxCustomSkill]);
  });
}
Future<void> talentSerializationTest() async {
  Talent basicTalent = await TalentFactory().create({"ID": 1});
  Talent minCustomTalent = await TalentFactory().create({
    "ID": 1,
    "NAME": "Test"
  });
  Talent maxCustomTalent = await TalentFactory().create({
    "ID": 1,
    "NAME": "Test",
    "SPECIALISATION": "Test2",
    "BASE_TALENT": {
      "ID": 1,
      "NAME": "Test3",
      "DESCRIPTION": "Test4",
      "SOURCE": "Main Rulebook",
      "CONST_LVL": null,
      "MAX_LVL": 1,
      "GROUPED": 1,
    },
    "TESTS": [
      {
        "BASE_SKILL_ID": 1,
        "COMMENT": "Test5"
      },
      {
        "SKILL_ID": 1,
      },
      {
        "ATTRIBUTE_ID": 1,
      }
    ],
    "LVL": 1,
    "ADVANCABLE": true
  });

  group("Talent", () {
    test("Basic from database", () {
      expect(basicTalent.id, 1);
      expect(basicTalent.name, "PHARMACIST");
      expect(basicTalent.specialisation, null);
      expect(basicTalent.baseTalent!.id, 1);
      expect(basicTalent.baseTalent!.name, "PHARMACIST");
      expect(basicTalent.baseTalent!.description, "PHARMACIST_DESC");
      expect(basicTalent.baseTalent!.source, "Main Rulebook");
      expect(basicTalent.baseTalent!.constLvl, null);
      expect(basicTalent.baseTalent!.grouped, false);
      expect(basicTalent.tests[0].id, 1);
      expect(basicTalent.tests[0].comment, null);
    });
    test("Minimal custom", () {
      expect(minCustomTalent.id, 1);
      expect(minCustomTalent.name, "Test");
    });
    test("Maximal custom 1", () {
      expect(maxCustomTalent.id, 1);
      expect(maxCustomTalent.name, "Test");
      expect(maxCustomTalent.specialisation, "Test2");
      expect(maxCustomTalent.baseTalent!.id, 1);
      expect(maxCustomTalent.baseTalent!.name, "Test3");
      expect(maxCustomTalent.baseTalent!.description, "Test4");
      expect(maxCustomTalent.baseTalent!.source, "Main Rulebook");
      expect(maxCustomTalent.baseTalent!.constLvl, null);
      expect(maxCustomTalent.baseTalent!.grouped, true);
      expect(maxCustomTalent.tests[0].id, 1);
      expect(maxCustomTalent.tests[0].comment, null);
    });
    doubleSerializationTest(TalentFactory(), [basicTalent, minCustomTalent, maxCustomTalent]);
  });
}