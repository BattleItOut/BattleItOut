import 'dart:convert';
import 'dart:io';

import 'package:battle_it_out/persistence/dao/attribute_dao.dart';
import 'package:battle_it_out/persistence/dao/character_dao.dart';
import 'package:battle_it_out/persistence/dao/item/armour_dao.dart';
import 'package:battle_it_out/persistence/dao/item/melee_weapon_dao.dart';
import 'package:battle_it_out/persistence/dao/item/ranged_weapon_dao.dart';
import 'package:battle_it_out/persistence/dao/profession_dao.dart';
import 'package:battle_it_out/persistence/dao/race_dao.dart';
import 'package:battle_it_out/persistence/dao/skill_dao.dart';
import 'package:battle_it_out/persistence/dao/talent_dao.dart';
import 'package:battle_it_out/persistence/entities/attribute.dart';
import 'package:battle_it_out/persistence/entities/character.dart';
import 'package:battle_it_out/persistence/entities/item/armour.dart';
import 'package:battle_it_out/persistence/entities/item/melee_weapon.dart';
import 'package:battle_it_out/persistence/entities/item/ranged_weapon.dart';
import 'package:battle_it_out/persistence/entities/profession.dart';
import 'package:battle_it_out/persistence/entities/race.dart';
import 'package:battle_it_out/persistence/entities/skill.dart';
import 'package:battle_it_out/persistence/entities/talent.dart';
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

void doubleSerializationTest(factory, list) {
  test("Serialize and deserialize", () async {
    for (var map in list) {
      var object = await factory.create(map);
      Map<String, dynamic> serializedMap = await factory.toMap(object);
      expect(serializedMap, map);
      var serializedObject = await factory.create(serializedMap);
      expect(serializedObject, object);
    }
  });
}

void raceSerializationTest() {
  Map<String, dynamic> basicRaceMap = {"ID": 1};
  Map<String, dynamic> minCustomRaceMap = {
    "NAME": "Test",
    "SIZE": 4
  };
  Map<String, dynamic> maxCustomRaceMap = {
    "NAME": "Test",
    "SIZE": 4,
    "EXTRA_POINTS": 4,
    "SUBRACE": {
      "NAME": "Test2",
      "RANDOM_TALENTS": 3
    }
  };

  group("Race serialization", () {
    test("Basic from database", () async {
      Race basicRace = await RaceFactory().create(basicRaceMap);
      expect(basicRace.databaseId, 1);
      expect(basicRace.name, "HUMAN");
      expect(basicRace.size.id, 4);
      expect(basicRace.extraPoints, 3);
      expect(basicRace.source, "Main Rulebook");
      expect(basicRace.subrace!.databaseId, 1);
      expect(basicRace.subrace!.name, "REIKLANDER");
    });
    test("Minimal custom", () async {
      Race minCustomRace = await RaceFactory().create(minCustomRaceMap);
      expect(minCustomRace.databaseId, null);
      expect(minCustomRace.name, "Test");
      expect(minCustomRace.size.id, 4);
      expect(minCustomRace.extraPoints, 0);
      expect(minCustomRace.source, "Custom");
      expect(minCustomRace.subrace, null);
    });
    test("Maximal custom", () async {
      Race maxCustomRace = await RaceFactory().create(maxCustomRaceMap);
      expect(maxCustomRace.databaseId, null);
      expect(maxCustomRace.name, "Test");
      expect(maxCustomRace.size.id, 4);
      expect(maxCustomRace.extraPoints, 4);
      expect(maxCustomRace.source, "Custom");
      expect(maxCustomRace.subrace!.name, "Test2");
      expect(maxCustomRace.subrace!.randomTalents, 3);
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
      "CLASS": {
        "NAME": "Test3"
      }
    }
  };

  group("Profession serialization", () {
    test("Basic from database", () async {
      Profession basicProfession = await ProfessionFactory().create(basicProfessionMap);
      expect(basicProfession.databaseId, 1);
      expect(basicProfession.name, "APOTHECARY_1");
      expect(basicProfession.source, "Main Rulebook");
      expect(basicProfession.level!, 1);
      expect(basicProfession.career!.databaseId, 1);
      expect(basicProfession.career!.name, "APOTHECARY_2");
      expect(basicProfession.career!.source, "Main Rulebook");
      expect(basicProfession.career!.professionClass!.databaseId, 1);
      expect(basicProfession.career!.professionClass!.name, "ACADEMIC");
      expect(basicProfession.career!.professionClass!.source, "Main Rulebook");
    });
    test("Minimal custom", () async {
      Profession minCustomProfession = await ProfessionFactory().create(minCustomProfessionMap);
      expect(minCustomProfession.databaseId, null);
      expect(minCustomProfession.name, "Test");
      expect(minCustomProfession.source, "Custom");
      expect(minCustomProfession.career, null);
    });
    test("Maximal custom", () async {
      Profession maxCustomProfession = await ProfessionFactory().create(maxCustomProfessionMap);
      expect(maxCustomProfession.databaseId, null);
      expect(maxCustomProfession.name, "Test");
      expect(maxCustomProfession.source, "Custom");
      expect(maxCustomProfession.career!.name, "Test2");
      expect(maxCustomProfession.career!.source, "Custom");
      expect(maxCustomProfession.career!.professionClass!.name, "Test3");
      expect(maxCustomProfession.career!.professionClass!.source, "Custom");
    });
    doubleSerializationTest(ProfessionFactory(), [basicProfessionMap, minCustomProfessionMap, maxCustomProfessionMap]);
  });
}
void attributeSerializationTest() {
  Map<String, dynamic> basicAttributeMap = {"ID": 1};
  Map<String, dynamic> maxEditedAttributeMap = {
    "ID": 1,
    "BASE": 38,
    "ADVANCES": 5,
    "ADVANCABLE": true
  };

  group("Attribute serialization", () {
    test("Basic from database", () async {
      Attribute basicAttribute = await AttributeFactory().create(basicAttributeMap);
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
    test("Edited", () async {
      Attribute maxEditedAttribute = await AttributeFactory().create(maxEditedAttributeMap);
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
    doubleSerializationTest(AttributeFactory(), [basicAttributeMap, maxEditedAttributeMap]);
  });
}
void skillSerializationTest() {
  Map<String, dynamic> basicSkillMap = {"ID": 1};
  Map<String, dynamic> maxEditedSkillMap = {
    "ID": 1,
    "ADVANCES": 2,
    "ADVANCABLE": true,
    "EARNING": true
  };

  group("Skill serialization", () {
    test("Basic from database", () async {
      Skill basicSkill = await SkillFactory().create(basicSkillMap);
      expect(basicSkill.databaseId, 1);
      expect(basicSkill.name, "ATHLETICS");
      expect(basicSkill.specialisation, null);
      expect(basicSkill.advances, 0);
      expect(basicSkill.canAdvance, false);
      expect(basicSkill.baseSkill!.databaseId, 1);
      expect(basicSkill.baseSkill!.name, "ATHLETICS");
      expect(basicSkill.baseSkill!.description, "ATHLETICS_DESC");
      expect(basicSkill.baseSkill!.advanced, false);
      expect(basicSkill.baseSkill!.grouped, false);
    });
    test("Edited", () async {
      Skill maxEditedSkill = await SkillFactory().create(maxEditedSkillMap);
      expect(maxEditedSkill.databaseId, 1);
      expect(maxEditedSkill.name, "ATHLETICS");
      expect(maxEditedSkill.specialisation, null);
      expect(maxEditedSkill.advances, 2);
      expect(maxEditedSkill.canAdvance, true);
      expect(maxEditedSkill.earning, true);
      expect(maxEditedSkill.baseSkill!.databaseId, 1);
      expect(maxEditedSkill.baseSkill!.name, "ATHLETICS");
      expect(maxEditedSkill.baseSkill!.description, "ATHLETICS_DESC");
      expect(maxEditedSkill.baseSkill!.advanced, false);
      expect(maxEditedSkill.baseSkill!.grouped, false);
    });
    doubleSerializationTest(SkillFactory(), [basicSkillMap, maxEditedSkillMap]);
  });
}
void talentSerializationTest() {
  Map<String, dynamic> basicTalentMap = {"ID": 1};
  Map<String, dynamic> maxEditedTalentMap = {
    "ID": 1,
    "LVL": 1,
    "ADVANCABLE": true
  };

  group("Talent serialization", () {
    test("Basic from database", () async {
      Talent basicTalent = await TalentFactory().create(basicTalentMap);
      expect(basicTalent.databaseId, 1);
      expect(basicTalent.name, "PHARMACIST");
      expect(basicTalent.specialisation, null);
      expect(basicTalent.currentLvl, 0);
      expect(basicTalent.canAdvance, false);
      expect(basicTalent.baseTalent!.databaseId, 1);
      expect(basicTalent.baseTalent!.name, "PHARMACIST");
      expect(basicTalent.baseTalent!.description, "PHARMACIST_DESC");
      expect(basicTalent.baseTalent!.source, "Main Rulebook");
      expect(basicTalent.baseTalent!.constLvl, null);
      expect(basicTalent.baseTalent!.grouped, false);
      expect(basicTalent.tests[0].databaseId, 1);
      expect(basicTalent.tests[0].comment, null);
    });
    test("Edited", () async {
      Talent maxEditedTalent = await TalentFactory().create(maxEditedTalentMap);
      expect(maxEditedTalent.databaseId, 1);
      expect(maxEditedTalent.name, "PHARMACIST");
      expect(maxEditedTalent.specialisation, null);
      expect(maxEditedTalent.currentLvl, 1);
      expect(maxEditedTalent.canAdvance, true);
      expect(maxEditedTalent.baseTalent!.databaseId, 1);
      expect(maxEditedTalent.baseTalent!.name, "PHARMACIST");
      expect(maxEditedTalent.baseTalent!.description, "PHARMACIST_DESC");
      expect(maxEditedTalent.baseTalent!.source, "Main Rulebook");
      expect(maxEditedTalent.baseTalent!.constLvl, null);
      expect(maxEditedTalent.baseTalent!.grouped, false);
      expect(maxEditedTalent.tests[0].databaseId, 1);
      expect(maxEditedTalent.tests[0].comment, null);
    });
    doubleSerializationTest(TalentFactory(), [basicTalentMap, maxEditedTalentMap]);
  });
}
void armourSerializationTest() {
  Map<String, dynamic> basicArmourMap = {"ID": 1};
  Map<String, dynamic> minCustomArmourMap = {
    "NAME": "Test",
    "HEAD_AP": 1
  };
  Map<String, dynamic> maxCustomArmourMap = {
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
  };

  group("Armour serialization", () {
    test("Basic from database", () async {
      Armour basicArmour = await ArmourFactory().create(basicArmourMap);
      expect(basicArmour.databaseId, 1);
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
      expect(minCustomArmour.databaseId, null);
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
      expect(maxCustomArmour.databaseId, null);
      expect(maxCustomArmour.name, "Test2");
      expect(maxCustomArmour.headAP, 1);
      expect(maxCustomArmour.bodyAP, 1);
      expect(maxCustomArmour.leftArmAP, 1);
      expect(maxCustomArmour.rightArmAP, 1);
      expect(maxCustomArmour.leftLegAP, 1);
      expect(maxCustomArmour.rightLegAP, 1);
      expect(maxCustomArmour.qualities[0].databaseId, 1);
      expect(maxCustomArmour.qualities[0].name, "LIGHTWEIGHT");
      expect(maxCustomArmour.qualities[1].databaseId, 2);
      expect(maxCustomArmour.qualities[1].name, "PRACTICAL");
    });
    doubleSerializationTest(ArmourFactory(), [basicArmourMap, minCustomArmourMap, maxCustomArmourMap]);
  });
}
void meleeWeaponSerializationTest() {
  Map<String, dynamic> basicMeleeWeaponMap = {"ID": 1};
  Map<String, dynamic> minCustomWeaponMap = {
    "NAME": "Test",
    "LENGTH": 1,
    "DAMAGE": 2
  };
  Map<String, dynamic> maxCustomWeaponMap = {
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
  };

  group("Melee weapon serialization", () {
    test("Basic from database", () async {
      MeleeWeapon basicMeleeWeapon = await MeleeWeaponFactory().create(basicMeleeWeaponMap);
      expect(basicMeleeWeapon.databaseId, 1);
      expect(basicMeleeWeapon.name, "SWORD");
      expect(basicMeleeWeapon.length.id, 4);
      expect(basicMeleeWeapon.damage, 4);
      expect(basicMeleeWeapon.qualities.length, 0);
    });
    test("Minimal custom", () async {
      MeleeWeapon minCustomWeapon = await MeleeWeaponFactory().create(minCustomWeaponMap);
      expect(minCustomWeapon.databaseId, null);
      expect(minCustomWeapon.name, "Test");
      expect(minCustomWeapon.length.id, 1);
      expect(minCustomWeapon.damage, 2);
      expect(minCustomWeapon.qualities.length, 0);
    });
    test("Maximal custom", () async {
      MeleeWeapon maxCustomWeapon = await MeleeWeaponFactory().create(maxCustomWeaponMap);
      expect(maxCustomWeapon.databaseId, null);
      expect(maxCustomWeapon.name, "Test2");
      expect(maxCustomWeapon.length.id, 1);
      expect(maxCustomWeapon.damage, 2);
      expect(maxCustomWeapon.qualities.length, 2);
      expect(maxCustomWeapon.qualities[0].databaseId, 1);
      expect(maxCustomWeapon.qualities[0].name, "LIGHTWEIGHT");
      expect(maxCustomWeapon.qualities[1].databaseId, 2);
      expect(maxCustomWeapon.qualities[1].name, "PRACTICAL");
    });
    doubleSerializationTest(MeleeWeaponFactory(), [basicMeleeWeaponMap, minCustomWeaponMap, maxCustomWeaponMap]);
  });
}
void rangedWeaponSerializationTest() {
  Map<String, dynamic> basicRangedWeaponMap = {"ID": 1};
  Map<String, dynamic> minCustomWeaponMap = {
    "NAME": "Test",
    "WEAPON_RANGE": 100,
    "DAMAGE": 2
  };
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
      {
      "ID": 1
      },
      {
      "ID": 2
      }
    ]
  };

  group("Ranged weapon serialization", () {
    test("Basic from database", () async {
      RangedWeapon basicRangedWeapon = await RangedWeaponFactory().create(basicRangedWeaponMap);
      expect(basicRangedWeapon.databaseId, 1);
      expect(basicRangedWeapon.name, "BLUNDERBUSS");
      expect(basicRangedWeapon.range, 20);
      expect(basicRangedWeapon.damage, 8);
      expect(basicRangedWeapon.qualities.length, 0);
    });
    test("Minimal custom", () async {
      RangedWeapon minCustomWeapon = await RangedWeaponFactory().create(minCustomWeaponMap);
      expect(minCustomWeapon.databaseId, null);
      expect(minCustomWeapon.name, "Test");
      expect(minCustomWeapon.range, 100);
      expect(minCustomWeapon.damage, 2);
      expect(minCustomWeapon.qualities.length, 0);
    });
    test("Maximal custom", () async {
      RangedWeapon maxCustomWeapon = await RangedWeaponFactory().create(maxCustomWeaponMap);
      expect(maxCustomWeapon.databaseId, null);
      expect(maxCustomWeapon.name, "Test2");
      expect(maxCustomWeapon.range, 100);
      expect(maxCustomWeapon.damage, 2);
      expect(maxCustomWeapon.ammunition[0].databaseId, 1);
      expect(maxCustomWeapon.ammunition[0].count, 10);
      expect(maxCustomWeapon.qualities[0].databaseId, 1);
      expect(maxCustomWeapon.qualities[0].name, "LIGHTWEIGHT");
      expect(maxCustomWeapon.qualities[1].databaseId, 2);
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
      expect(serialisedCharacter, map);
      var character2 = await CharacterFactory().fromMap(map);
      expect(character2, character);
    });
  });
}