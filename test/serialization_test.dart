import 'dart:convert';
import 'dart:io';

import 'package:battle_it_out/persistence/attribute.dart';
import 'package:battle_it_out/persistence/character.dart';
import 'package:battle_it_out/persistence/item/armour.dart';
import 'package:battle_it_out/persistence/item/melee_weapon.dart';
import 'package:battle_it_out/persistence/item/ranged_weapon.dart';
import 'package:battle_it_out/persistence/profession/profession.dart';
import 'package:battle_it_out/persistence/race.dart';
import 'package:battle_it_out/persistence/serializer.dart';
import 'package:battle_it_out/persistence/skill/skill.dart';
import 'package:battle_it_out/persistence/subrace.dart';
import 'package:battle_it_out/persistence/talent/talent.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> main() async {
  group("Serialization", () {
    TestWidgetsFlutterBinding.ensureInitialized();
    raceSerializationTest();
    professionSerializationTest();
    attributeSerializationTest();
    skillSerializationTest();
    talentSerializationTest();
    armourSerializationTest();
    meleeWeaponSerializationTest();
    rangedWeaponSerializationTest();
    characterSerializationTest();
  });
}

void doubleSerializationTest(Factory factory, List list) {
  for (var i = 0; i < list.length; i++) {
    test("Serialize and deserialize - ${i + 1}", () async {
      var object = await factory.create(list[i]);
      Map<String, dynamic> serializedMap = await factory.toMap(object, optimised: false);
      var serializedObject = await factory.create(serializedMap);
      expect(serializedObject, object);
    });
  }
}

void raceSerializationTest() {
  Map<String, dynamic> basicRaceMap = {"ID": 1};
  Map<String, dynamic> minCustomRaceMap = {"NAME": "Test"};
  Map<String, dynamic> maxCustomRaceMap = {
    "NAME": "Test",
    "RANDOM_TALENTS": 3,
    "RACE": {
      "NAME": "Test2",
      "EXTRA_POINTS": 4,
      "SIZE": 4,
    }
  };

  group("Race serialization", () {
    test("Basic from database", () async {
      Subrace basicRace = await SubraceFactory().create(basicRaceMap);
      expect(basicRace.id, 1);
      expect(basicRace.name, "REIKLANDER");
      expect(basicRace.source, "Main Rulebook");
      expect(basicRace.race.id, 1);
      expect(basicRace.race.name, "HUMAN");
      expect(basicRace.race.size.id, 4);
    });
    test("Minimal custom", () async {
      Subrace minCustomRace = await SubraceFactory().create(minCustomRaceMap);
      expect(minCustomRace.id, 10);
      expect(minCustomRace.name, "Test");
      expect(minCustomRace.source, "Custom");
      expect(minCustomRace.race.size.id, 4);
    });
    test("Maximal custom", () async {
      Subrace maxCustomRace = await SubraceFactory().create(maxCustomRaceMap);
      expect(maxCustomRace.id, 11);
      expect(maxCustomRace.name, "Test");
      expect(maxCustomRace.source, "Custom");
      expect(maxCustomRace.randomTalents, 3);
      expect(maxCustomRace.race.name, "Test2");
      expect(maxCustomRace.race.size.id, 4);
    });
    doubleSerializationTest(RaceFactory(), [basicRaceMap, minCustomRaceMap, maxCustomRaceMap]);
  });
}

void professionSerializationTest() {
  Map<String, dynamic> basicProfessionMap = {"ID": 1};
  Map<String, dynamic> minCustomProfessionMap = {"NAME": "Test"};
  Map<String, dynamic> maxCustomProfessionMap = {
    "NAME": "Test",
    "LEVEL": 1,
    "CAREER": {
      "NAME": "Test2",
      "CLASS": {"NAME": "Test3"}
    }
  };

  group("Profession serialization", () {
    test("Basic from database", () async {
      Profession basicProfession = await ProfessionFactory().create(basicProfessionMap);
      expect(basicProfession.id, 1);
      expect(basicProfession.name, "APOTHECARY_1");
      expect(basicProfession.source, "Main Rulebook");
      expect(basicProfession.level, 1);
      expect(basicProfession.career.id, 1);
      expect(basicProfession.career.name, "APOTHECARY_2");
      expect(basicProfession.career.source, "Main Rulebook");
      expect(basicProfession.career.professionClass.id, 1);
      expect(basicProfession.career.professionClass.name, "ACADEMIC");
      expect(basicProfession.career.professionClass.source, "Main Rulebook");
    });
    test("Minimal custom", () async {
      Profession minCustomProfession = await ProfessionFactory().create(minCustomProfessionMap);
      expect(minCustomProfession.id, 257);
      expect(minCustomProfession.name, "Test");
      expect(minCustomProfession.source, "Custom");
    });
    test("Maximal custom", () async {
      Profession maxCustomProfession = await ProfessionFactory().create(maxCustomProfessionMap);
      expect(maxCustomProfession.id, 258);
      expect(maxCustomProfession.name, "Test");
      expect(maxCustomProfession.source, "Custom");
      expect(maxCustomProfession.career.name, "Test2");
      expect(maxCustomProfession.career.source, "Custom");
      expect(maxCustomProfession.career.professionClass.name, "Test3");
      expect(maxCustomProfession.career.professionClass.source, "Custom");
    });
    doubleSerializationTest(ProfessionFactory(), [basicProfessionMap, minCustomProfessionMap, maxCustomProfessionMap]);
  });
}

void attributeSerializationTest() {
  Map<String, dynamic> basicAttributeMap = {"ID": 1};
  Map<String, dynamic> maxEditedAttributeMap = {"ID": 1, "BASE": 38, "ADVANCES": 5, "CAN_ADVANCE": true};

  group("Attribute serialization", () {
    test("Basic from database", () async {
      Attribute basicAttribute = await AttributeFactory().create(basicAttributeMap);
      expect(basicAttribute.id, 1);
      expect(basicAttribute.name, "WEAPON_SKILL");
      expect(basicAttribute.shortName, "WEAPON_SKILL_SHORT");
      expect(basicAttribute.description, "WEAPON_SKILL_DESC");
      expect(basicAttribute.canRoll, true);
      expect(basicAttribute.importance, 0);
      expect(basicAttribute.base, 0);
      expect(basicAttribute.advances, 0);
      expect(basicAttribute.canAdvance, false);
    });
    test("Edited", () async {
      Attribute maxEditedAttribute = await AttributeFactory().create(maxEditedAttributeMap);
      expect(maxEditedAttribute.id, 1);
      expect(maxEditedAttribute.name, "WEAPON_SKILL");
      expect(maxEditedAttribute.shortName, "WEAPON_SKILL_SHORT");
      expect(maxEditedAttribute.description, "WEAPON_SKILL_DESC");
      expect(maxEditedAttribute.canRoll, true);
      expect(maxEditedAttribute.importance, 0);
      expect(maxEditedAttribute.base, 38);
      expect(maxEditedAttribute.advances, 5);
      expect(maxEditedAttribute.canAdvance, true);
    });
    doubleSerializationTest(AttributeFactory(), [basicAttributeMap, maxEditedAttributeMap]);
  });
}

void skillSerializationTest() {
  Map<String, dynamic> basicSkillMap = {"ID": 1};
  Map<String, dynamic> maxEditedSkillMap = {"ID": 1, "ADVANCES": 2, "CAN_ADVANCE": true, "EARNING": true};

  group("Skill serialization", () {
    test("Basic from database", () async {
      Skill basicSkill = await SkillFactory().create(basicSkillMap);
      expect(basicSkill.id, 1);
      expect(basicSkill.name, "ATHLETICS");
      expect(basicSkill.specialisation, null);
      expect(basicSkill.advances, 0);
      expect(basicSkill.canAdvance, false);
      expect(basicSkill.baseSkill.id, 1);
      expect(basicSkill.baseSkill.name, "ATHLETICS");
      expect(basicSkill.baseSkill.description, "ATHLETICS_DESC");
      expect(basicSkill.baseSkill.advanced, false);
      expect(basicSkill.baseSkill.grouped, false);
    });
    test("Edited", () async {
      Skill maxEditedSkill = await SkillFactory().create(maxEditedSkillMap);
      expect(maxEditedSkill.id, 1);
      expect(maxEditedSkill.name, "ATHLETICS");
      expect(maxEditedSkill.specialisation, null);
      expect(maxEditedSkill.advances, 2);
      expect(maxEditedSkill.canAdvance, true);
      expect(maxEditedSkill.earning, true);
      expect(maxEditedSkill.baseSkill.id, 1);
      expect(maxEditedSkill.baseSkill.name, "ATHLETICS");
      expect(maxEditedSkill.baseSkill.description, "ATHLETICS_DESC");
      expect(maxEditedSkill.baseSkill.advanced, false);
      expect(maxEditedSkill.baseSkill.grouped, false);
    });
    doubleSerializationTest(SkillFactory(), [basicSkillMap, maxEditedSkillMap]);
  });
}

void talentSerializationTest() {
  Map<String, dynamic> basicTalentMap = {"ID": 1};
  Map<String, dynamic> maxEditedTalentMap = {"ID": 1, "LVL": 1, "CAN_ADVANCE": true};

  group("Talent serialization", () {
    test("Basic from database", () async {
      Talent basicTalent = await TalentFactory().create(basicTalentMap);
      expect(basicTalent.id, 1);
      expect(basicTalent.name, "PHARMACIST");
      expect(basicTalent.specialisation, null);
      expect(basicTalent.currentLvl, 0);
      expect(basicTalent.canAdvance, false);
      expect(basicTalent.baseTalent!.id, 1);
      expect(basicTalent.baseTalent!.name, "PHARMACIST");
      expect(basicTalent.baseTalent!.description, "PHARMACIST_DESC");
      expect(basicTalent.baseTalent!.source, "Main Rulebook");
      expect(basicTalent.baseTalent!.constLvl, null);
      expect(basicTalent.baseTalent!.grouped, false);
      expect(basicTalent.tests[0].id, 1);
      expect(basicTalent.tests[0].comment, null);
    });
    test("Edited", () async {
      Talent maxEditedTalent = await TalentFactory().create(maxEditedTalentMap);
      expect(maxEditedTalent.id, 1);
      expect(maxEditedTalent.name, "PHARMACIST");
      expect(maxEditedTalent.specialisation, null);
      expect(maxEditedTalent.currentLvl, 1);
      expect(maxEditedTalent.canAdvance, true);
      expect(maxEditedTalent.baseTalent!.id, 1);
      expect(maxEditedTalent.baseTalent!.name, "PHARMACIST");
      expect(maxEditedTalent.baseTalent!.description, "PHARMACIST_DESC");
      expect(maxEditedTalent.baseTalent!.source, "Main Rulebook");
      expect(maxEditedTalent.baseTalent!.constLvl, null);
      expect(maxEditedTalent.baseTalent!.grouped, false);
      expect(maxEditedTalent.tests[0].id, 1);
      expect(maxEditedTalent.tests[0].comment, null);
    });
    doubleSerializationTest(TalentFactory(), [basicTalentMap, maxEditedTalentMap]);
  });
}

void armourSerializationTest() {
  Map<String, dynamic> basicArmourMap = {"ID": 1};
  Map<String, dynamic> minCustomArmourMap = {"NAME": "Test", "HEAD_AP": 1};
  Map<String, dynamic> maxCustomArmourMap = {
    "NAME": "Test2",
    "HEAD_AP": 1,
    "BODY_AP": 1,
    "LEFT_ARM_AP": 1,
    "RIGHT_ARM_AP": 1,
    "LEFT_LEG_AP": 1,
    "RIGHT_LEG_AP": 1,
    "QUALITIES": [
      {"ID": 1},
      {"ID": 2},
      {"NAME": "CUSTOM"}
    ]
  };

  group("Armour serialization", () {
    test("Basic from database", () async {
      Armour basicArmour = await ArmourFactory().create(basicArmourMap);
      expect(basicArmour.id, 1);
      expect(basicArmour.name, "LEATHER_JACK");
      expect(basicArmour.headAP, 0);
      expect(basicArmour.bodyAP, 1);
      expect(basicArmour.leftArmAP, 1);
      expect(basicArmour.rightArmAP, 1);
      expect(basicArmour.leftLegAP, 0);
      expect(basicArmour.rightLegAP, 0);
    });
    test("Minimal custom", () async {
      Armour minCustomArmour = await ArmourFactory().create(minCustomArmourMap);
      expect(minCustomArmour.id, 15);
      expect(minCustomArmour.name, "Test");
      expect(minCustomArmour.headAP, 1);
      expect(minCustomArmour.bodyAP, 0);
      expect(minCustomArmour.leftArmAP, 0);
      expect(minCustomArmour.rightArmAP, 0);
      expect(minCustomArmour.leftLegAP, 0);
      expect(minCustomArmour.rightLegAP, 0);
    });
    test("Maximal custom", () async {
      Armour maxCustomArmour = await ArmourFactory().create(maxCustomArmourMap);
      expect(maxCustomArmour.id, 16);
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
      expect(maxCustomArmour.qualities[2].id, 43);
      expect(maxCustomArmour.qualities[2].name, "CUSTOM");
    });
    doubleSerializationTest(ArmourFactory(), [basicArmourMap, minCustomArmourMap, maxCustomArmourMap]);
  });
}

void meleeWeaponSerializationTest() {
  Map<String, dynamic> basicMeleeWeaponMap = {"ID": 1};
  Map<String, dynamic> minCustomWeaponMap = {"NAME": "Test", "LENGTH": 1, "DAMAGE": 2};
  Map<String, dynamic> maxCustomWeaponMap = {
    "NAME": "Test2",
    "LENGTH": 1,
    "DAMAGE": 2,
    "QUALITIES": [
      {"ID": 1},
      {"ID": 2}
    ]
  };

  group("Melee weapon serialization", () {
    test("Basic from database", () async {
      MeleeWeapon basicMeleeWeapon = await MeleeWeaponFactory().create(basicMeleeWeaponMap);
      expect(basicMeleeWeapon.id, 1);
      expect(basicMeleeWeapon.name, "SWORD");
      expect(basicMeleeWeapon.length.id, 4);
      expect(basicMeleeWeapon.damage, 4);
      expect(basicMeleeWeapon.qualities.length, 0);
    });
    test("Minimal custom", () async {
      MeleeWeapon minCustomWeapon = await MeleeWeaponFactory().create(minCustomWeaponMap);
      expect(minCustomWeapon.id, 60);
      expect(minCustomWeapon.name, "Test");
      expect(minCustomWeapon.length.id, 1);
      expect(minCustomWeapon.damage, 2);
      expect(minCustomWeapon.qualities.length, 0);
    });
    test("Maximal custom", () async {
      MeleeWeapon maxCustomWeapon = await MeleeWeaponFactory().create(maxCustomWeaponMap);
      expect(maxCustomWeapon.id, 61);
      expect(maxCustomWeapon.name, "Test2");
      expect(maxCustomWeapon.length.id, 1);
      expect(maxCustomWeapon.damage, 2);
      expect(maxCustomWeapon.qualities.length, 2);
      expect(maxCustomWeapon.qualities[0].id, 1);
      expect(maxCustomWeapon.qualities[0].name, "LIGHTWEIGHT");
      expect(maxCustomWeapon.qualities[1].id, 2);
      expect(maxCustomWeapon.qualities[1].name, "PRACTICAL");
    });
    doubleSerializationTest(MeleeWeaponFactory(), [basicMeleeWeaponMap, minCustomWeaponMap, maxCustomWeaponMap]);
  });
}

void rangedWeaponSerializationTest() {
  Map<String, dynamic> basicRangedWeaponMap = {"ID": 1};
  Map<String, dynamic> minCustomWeaponMap = {"NAME": "Test", "WEAPON_RANGE": 100, "DAMAGE": 2};
  Map<String, dynamic> maxCustomWeaponMap = {
    "NAME": "Test2",
    "WEAPON_RANGE": 100,
    "DAMAGE": 2,
    "AMMUNITION": [
      {
        "ID": 1,
        "COUNT": 10,
      }
    ],
    "QUALITIES": [
      {"ID": 1},
      {"ID": 2}
    ]
  };

  group("Ranged weapon serialization", () {
    test("Basic from database", () async {
      RangedWeapon basicRangedWeapon = await RangedWeaponFactory().create(basicRangedWeaponMap);
      expect(basicRangedWeapon.id, 1);
      expect(basicRangedWeapon.name, "BLUNDERBUSS");
      expect(basicRangedWeapon.range, 20);
      expect(basicRangedWeapon.damage, 8);
      expect(basicRangedWeapon.qualities.length, 2);
    });
    test("Minimal custom", () async {
      RangedWeapon minCustomWeapon = await RangedWeaponFactory().create(minCustomWeaponMap);
      expect(minCustomWeapon.id, 42);
      expect(minCustomWeapon.name, "Test");
      expect(minCustomWeapon.range, 100);
      expect(minCustomWeapon.damage, 2);
      expect(minCustomWeapon.qualities.length, 0);
    });
    test("Maximal custom", () async {
      RangedWeapon maxCustomWeapon = await RangedWeaponFactory().create(maxCustomWeaponMap);
      expect(maxCustomWeapon.id, 43);
      expect(maxCustomWeapon.name, "Test2");
      expect(maxCustomWeapon.range, 100);
      expect(maxCustomWeapon.damage, 2);
      expect(maxCustomWeapon.ammunition[0].id, 1);
      expect(maxCustomWeapon.ammunition[0].count, 10);
      expect(maxCustomWeapon.qualities[0].id, 1);
      expect(maxCustomWeapon.qualities[0].name, "LIGHTWEIGHT");
      expect(maxCustomWeapon.qualities[1].id, 2);
      expect(maxCustomWeapon.qualities[1].name, "PRACTICAL");
    });
    doubleSerializationTest(RangedWeaponFactory(), [basicRangedWeaponMap, minCustomWeaponMap, maxCustomWeaponMap]);
  });
}

void characterSerializationTest() {
  group("Character serialization", () {
    test("Serialize and deserialize", () async {
      File file = File('assets/test/character_test2.json');
      Map<String, dynamic> serialisedCharacter = jsonDecode(await file.readAsString());
      Character character = await CharacterFactory().fromMap(serialisedCharacter);
      Map<String, dynamic> map = await CharacterFactory().toMap(character);
      Character character2 = await CharacterFactory().fromMap(map);
      expect(character2, character);
    });
  });
}
