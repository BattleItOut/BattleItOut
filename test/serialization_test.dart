import 'dart:convert';
import 'dart:io';

import 'package:battle_it_out/persistence/character.dart';
import 'package:battle_it_out/persistence/dao/armour_dao.dart';
import 'package:battle_it_out/persistence/dao/attribute_dao.dart';
import 'package:battle_it_out/persistence/dao/melee_weapon_dao.dart';
import 'package:battle_it_out/persistence/dao/profession_dao.dart';
import 'package:battle_it_out/persistence/dao/race_dao.dart';
import 'package:battle_it_out/persistence/dao/ranged_weapon_dao.dart';
import 'package:battle_it_out/persistence/dao/skill_dao.dart';
import 'package:battle_it_out/persistence/dao/talent_dao.dart';
import 'package:battle_it_out/persistence/entities/armour.dart';
import 'package:battle_it_out/persistence/entities/attribute.dart';
import 'package:battle_it_out/persistence/entities/melee_weapon.dart';
import 'package:battle_it_out/persistence/entities/profession.dart';
import 'package:battle_it_out/persistence/entities/race.dart';
import 'package:battle_it_out/persistence/entities/ranged_weapon.dart';
import 'package:battle_it_out/persistence/entities/skill.dart';
import 'package:battle_it_out/persistence/entities/talent.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await raceSerializationTest();
  await professionSerializationTest();
  await attributeSerializationTest();
  await skillSerializationTest();
  await talentSerializationTest();
  await armourSerializationTest();
  await meleeWeaponSerializationTest();
  await rangedWeaponSerializationTest();
  await characterSerializationTest();
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

  group("Race serialization", () {
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

  group("Profession serialization", () {
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
  Attribute maxEditedAttribute = await AttributeFactory().create({
    "ID": 1,
    "BASE": 38,
    "ADVANCES": 5,
    "ADVANCABLE": true
  });

  group("Attribute serialization", () {
    test("Basic from database", () {
      expect(basicAttribute.id, 1);
      expect(basicAttribute.name, "WEAPON_SKILL");
      expect(basicAttribute.shortName, "WEAPON_SKILL_SHORT");
      expect(basicAttribute.description, "WEAPON_SKILL_DESC");
      expect(basicAttribute.rollable, 1);
      expect(basicAttribute.importance, 0);
      expect(basicAttribute.base, 0);
      expect(basicAttribute.advances, 0);
      expect(basicAttribute.advancable, false);
    });
    test("Edited", () {
      expect(maxEditedAttribute.id, 1);
      expect(maxEditedAttribute.name, "WEAPON_SKILL");
      expect(maxEditedAttribute.shortName, "WEAPON_SKILL_SHORT");
      expect(maxEditedAttribute.description, "WEAPON_SKILL_DESC");
      expect(maxEditedAttribute.rollable, 1);
      expect(maxEditedAttribute.importance, 0);
      expect(maxEditedAttribute.base, 38);
      expect(maxEditedAttribute.advances, 5);
      expect(maxEditedAttribute.advancable, true);
    });
    doubleSerializationTest(AttributeFactory(), [basicAttribute, maxEditedAttribute]);
  });
}
Future<void> skillSerializationTest() async {
  Skill basicSkill = await SkillFactory().create({"ID": 1});
  Skill maxEditedSkill = await SkillFactory().create({
    "ID": 1,
    "ADVANCES": 2,
    "ADVANCABLE": true
  });

  group("Skill serialization", () {
    test("Basic from database", () {
      expect(basicSkill.id, 1);
      expect(basicSkill.name, "ATHLETICS");
      expect(basicSkill.specialisation, null);
      expect(basicSkill.advances, 0);
      expect(basicSkill.advancable, false);
      expect(basicSkill.baseSkill!.id, 1);
      expect(basicSkill.baseSkill!.name, "ATHLETICS");
      expect(basicSkill.baseSkill!.description, "ATHLETICS_DESC");
      expect(basicSkill.baseSkill!.advanced, false);
      expect(basicSkill.baseSkill!.grouped, false);
    });
    test("Edited", () {
      expect(maxEditedSkill.id, 1);
      expect(maxEditedSkill.name, "ATHLETICS");
      expect(maxEditedSkill.specialisation, null);
      expect(maxEditedSkill.advances, 2);
      expect(maxEditedSkill.advancable, true);
      expect(maxEditedSkill.baseSkill!.id, 1);
      expect(maxEditedSkill.baseSkill!.name, "ATHLETICS");
      expect(maxEditedSkill.baseSkill!.description, "ATHLETICS_DESC");
      expect(maxEditedSkill.baseSkill!.advanced, false);
      expect(maxEditedSkill.baseSkill!.grouped, false);
    });
    doubleSerializationTest(SkillFactory(), [basicSkill, maxEditedSkill]);
  });
}
Future<void> talentSerializationTest() async {
  Talent basicTalent = await TalentFactory().create({"ID": 1});
  Talent maxEditedTalent = await TalentFactory().create({
    "ID": 1,
    "LVL": 1,
    "ADVANCABLE": true
  });

  group("Talent serialization", () {
    test("Basic from database", () {
      expect(basicTalent.id, 1);
      expect(basicTalent.name, "PHARMACIST");
      expect(basicTalent.specialisation, null);
      expect(basicTalent.currentLvl, 0);
      expect(basicTalent.advancable, false);
      expect(basicTalent.baseTalent!.id, 1);
      expect(basicTalent.baseTalent!.name, "PHARMACIST");
      expect(basicTalent.baseTalent!.description, "PHARMACIST_DESC");
      expect(basicTalent.baseTalent!.source, "Main Rulebook");
      expect(basicTalent.baseTalent!.constLvl, null);
      expect(basicTalent.baseTalent!.grouped, false);
      expect(basicTalent.tests[0].id, 1);
      expect(basicTalent.tests[0].comment, null);
    });
    test("Edited", () {
      expect(maxEditedTalent.id, 1);
      expect(maxEditedTalent.name, "PHARMACIST");
      expect(maxEditedTalent.specialisation, null);
      expect(maxEditedTalent.currentLvl, 1);
      expect(maxEditedTalent.advancable, true);
      expect(maxEditedTalent.baseTalent!.id, 1);
      expect(maxEditedTalent.baseTalent!.name, "PHARMACIST");
      expect(maxEditedTalent.baseTalent!.description, "PHARMACIST_DESC");
      expect(maxEditedTalent.baseTalent!.source, "Main Rulebook");
      expect(maxEditedTalent.baseTalent!.constLvl, null);
      expect(maxEditedTalent.baseTalent!.grouped, false);
      expect(maxEditedTalent.tests[0].id, 1);
      expect(maxEditedTalent.tests[0].comment, null);
    });
    doubleSerializationTest(TalentFactory(), [basicTalent, maxEditedTalent]);
  });
}
Future<void> armourSerializationTest() async {
  Armour basicArmour = await ArmourFactory().create({"ID": 1});
  Armour minCustomArmour = await ArmourFactory().create({
    "NAME": "Test",
    "HEAD_AP": 1
  });
  Armour maxCustomArmour = await ArmourFactory().create({
    "NAME": "Test2",
    "HEAD_AP": 1,
    "BODY_AP": 1,
    "LEFT_ARM_AP": 1,
    "RIGHT_ARM_AP": 1,
    "LEFT_LEG_AP": 1,
    "RIGHT_LEG_AP": 1,
    "QUALITIES": [
      {
        "ID": 1
      },
      {
        "ID": 2
      }
    ]
  });

  group("Armour serialization", () {
    test("Basic from database", () {
      expect(basicArmour.id, 1);
      expect(basicArmour.name, "LEATHER_JACK");
      expect(basicArmour.headAP, 0);
      expect(basicArmour.bodyAP, 1);
      expect(basicArmour.leftArmAP, 1);
      expect(basicArmour.rightArmAP, 1);
      expect(basicArmour.leftLegAP, 0);
      expect(basicArmour.rightLegAP, 0);
    });
    test("Minimal custom", () {
      expect(minCustomArmour.id, null);
      expect(minCustomArmour.name, "Test");
      expect(minCustomArmour.headAP, 1);
      expect(minCustomArmour.bodyAP, 0);
      expect(minCustomArmour.leftArmAP, 0);
      expect(minCustomArmour.rightArmAP, 0);
      expect(minCustomArmour.leftLegAP, 0);
      expect(minCustomArmour.rightLegAP, 0);
    });
    test("Maximal custom", () {
      expect(maxCustomArmour.id, null);
      expect(maxCustomArmour.name, "Test2");
      expect(maxCustomArmour.headAP, 1);
      expect(maxCustomArmour.bodyAP, 1);
      expect(maxCustomArmour.leftArmAP, 1);
      expect(maxCustomArmour.rightArmAP, 1);
      expect(maxCustomArmour.leftLegAP, 1);
      expect(maxCustomArmour.rightLegAP, 1);
      expect(maxCustomArmour.qualities[0].id, 1);
      expect(maxCustomArmour.qualities[0].name, "LIGHTWEIGHT");
      expect(maxCustomArmour.qualities[1].id, 2);
      expect(maxCustomArmour.qualities[1].name, "PRACTICAL");
    });
    doubleSerializationTest(ArmourFactory(), [basicArmour, minCustomArmour, maxCustomArmour]);
  });
}
Future<void> meleeWeaponSerializationTest() async {
  MeleeWeapon basicMeleeWeapon = await MeleeWeaponFactory().create({"ID": 1});
  MeleeWeapon minCustomWeapon = await MeleeWeaponFactory().create({
    "NAME": "Test",
    "LENGTH": 1,
    "DAMAGE": 2
  });
  MeleeWeapon maxCustomWeapon = await MeleeWeaponFactory().create({
    "NAME": "Test2",
    "LENGTH": 1,
    "DAMAGE": 2,
    "QUALITIES": [
      {
      "ID": 1
      },
      {
      "ID": 2
      }
    ]
  });

  group("Melee weapon serialization", () {
    test("Basic from database", () {
      expect(basicMeleeWeapon.id, 1);
      expect(basicMeleeWeapon.name, "HAND_WEAPON");
      expect(basicMeleeWeapon.length.id, 4);
      expect(basicMeleeWeapon.damage, 4);
      expect(basicMeleeWeapon.qualities.length, 0);
    });
    test("Minimal custom", () {
      expect(minCustomWeapon.id, null);
      expect(minCustomWeapon.name, "Test");
      expect(minCustomWeapon.length.id, 1);
      expect(minCustomWeapon.damage, 2);
      expect(minCustomWeapon.qualities.length, 0);
    });
    test("Maximal custom", () {
      expect(maxCustomWeapon.id, null);
      expect(maxCustomWeapon.name, "Test2");
      expect(maxCustomWeapon.length.id, 1);
      expect(maxCustomWeapon.damage, 2);
      expect(maxCustomWeapon.qualities.length, 2);
      expect(maxCustomWeapon.qualities[0].id, 1);
      expect(maxCustomWeapon.qualities[0].name, "LIGHTWEIGHT");
      expect(maxCustomWeapon.qualities[1].id, 2);
      expect(maxCustomWeapon.qualities[1].name, "PRACTICAL");
    });
    doubleSerializationTest(MeleeWeaponFactory(), [basicMeleeWeapon, minCustomWeapon, maxCustomWeapon]);
  });
}
Future<void> rangedWeaponSerializationTest() async {
  RangedWeapon basicRangedWeapon = await RangedWeaponFactory().create({"ID": 1});
  RangedWeapon minCustomWeapon = await RangedWeaponFactory().create({
    "NAME": "Test",
    "WEAPON_RANGE": 100,
    "DAMAGE": 2
  });
  RangedWeapon maxCustomWeapon = await RangedWeaponFactory().create({
    "NAME": "Test2",
    "WEAPON_RANGE": 100,
    "DAMAGE": 2,
    "AMMUNITION": 10,
    "QUALITIES": [
      {
      "ID": 1
      },
      {
      "ID": 2
      }
    ]
  });

  group("Ranged weapon serialization", () {
    test("Basic from database", () {
      expect(basicRangedWeapon.id, 1);
      expect(basicRangedWeapon.name, "BLUNDERBUSS");
      expect(basicRangedWeapon.range, 20);
      expect(basicRangedWeapon.damage, 8);
      expect(basicRangedWeapon.qualities.length, 0);
    });
    test("Minimal custom", () {
      expect(minCustomWeapon.id, null);
      expect(minCustomWeapon.name, "Test");
      expect(minCustomWeapon.range, 100);
      expect(minCustomWeapon.damage, 2);
      expect(minCustomWeapon.qualities.length, 0);
    });
    test("Maximal custom", () {
      expect(maxCustomWeapon.id, null);
      expect(maxCustomWeapon.name, "Test2");
      expect(maxCustomWeapon.range, 100);
      expect(maxCustomWeapon.damage, 2);
      expect(maxCustomWeapon.ammunition, 10);
      expect(maxCustomWeapon.qualities[0].id, 1);
      expect(maxCustomWeapon.qualities[0].name, "LIGHTWEIGHT");
      expect(maxCustomWeapon.qualities[1].id, 2);
      expect(maxCustomWeapon.qualities[1].name, "PRACTICAL");
    });
    doubleSerializationTest(RangedWeaponFactory(), [basicRangedWeapon, minCustomWeapon, maxCustomWeapon]);
  });
}
Future<void> characterSerializationTest() async {
  group("Character serialization", () {
    test("Serialize and deserialize", () async {
      File file = File('assets/test/character_test2.json');
      Character character = await Character.create(jsonDecode(await file.readAsString()));

      Map<String, dynamic> map = character.toMap();
      var character2 = await Character.create(map);
      expect(character, character2);
    });
  });
}