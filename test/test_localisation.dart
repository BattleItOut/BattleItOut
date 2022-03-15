import 'package:battle_it_out/localisation.dart';
import 'package:battle_it_out/persistence/dao/armour_dao.dart';
import 'package:battle_it_out/persistence/dao/attribute_dao.dart';
import 'package:battle_it_out/persistence/dao/item_quality_dao.dart';
import 'package:battle_it_out/persistence/dao/length_dao.dart';
import 'package:battle_it_out/persistence/dao/melee_weapon_dao.dart';
import 'package:battle_it_out/persistence/dao/profession_dao.dart';
import 'package:battle_it_out/persistence/dao/race_dao.dart';
import 'package:battle_it_out/persistence/dao/ranged_weapon_dao.dart';
import 'package:battle_it_out/persistence/dao/size_dao.dart';
import 'package:battle_it_out/persistence/dao/skill_dao.dart';
import 'package:battle_it_out/persistence/dao/talent_dao.dart';
import 'package:battle_it_out/utils/utilities.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> localisationTest() async {
  var _languages = await AppLocalizationsDelegate.loadYML();
  for (var entry in _languages.entries) {
    String languageName = entry.key;
    Map<String, String> localisationMap = entry.value;

    group("Check language: $languageName", () {
      void performLocTest(name, var dao, var getter) {
        test(name, () async {
          for (var item in await dao.getAll()) {
            for (var param in getter(item)) {
              if (param != null) {
                expect(localisationMap.containsKey(param), true, reason: "String not localised: $param");
              }
            }
          }
        });
      }
      performLocTest("Check base talent localisations", BaseTalentDAO(), (item) => [item.name, item.description]);
      performLocTest("Check talent localisations", TalentDAO(), (item) => [item.name, item.specialisation]);
      performLocTest("Check profession class localisations", ProfessionCareerDAO(), (item) => [item.name]);
      performLocTest("Check profession career localisations", ProfessionCareerDAO(), (item) => [item.name]);
      performLocTest("Check profession localisations", ProfessionDAO(), (item) => [item.name]);
      performLocTest("Check race localisations", RaceDAO(), (item) => [item.name]);
      performLocTest("Check subrace localisations", SubraceDAO(), (item) => [item.name]);
      performLocTest("Check size localisations", SizeDAO(), (item) => [item.name]);
      performLocTest("Check armour localisations", ArmourDAO(), (item) => [item.name]);
      performLocTest("Check attribute localisations", AttributeDAO(), (item) => [item.name, item.shortName, item.description]);
      performLocTest("Check base skill localisations", BaseSkillDAO(), (item) => [item.name, item.description]);
      performLocTest("Check skill localisations", SkillDAO(), (item) => [item.name, item.specialisation]);
      performLocTest("Check weapon length localisations", WeaponLengthDAO(), (item) => [item.name, item.description]);
      performLocTest("Check melee weapon localisations", MeleeWeaponDAO(), (item) => [item.name]);
      performLocTest("Check ranged weapon localisations", RangedWeaponDTO(), (item) => [item.name]);
      performLocTest("Check item quality localisations", ItemQualityDAO(), (item) => [item.name, item.description]);
    });

    var testMap = {};
    for (var entry in localisationMap.entries) {
      if (testMap.containsKey(entry.value)) {
        testMap[entry.value].add(entry.key);
      } else {
        testMap[entry.value] = [];
      }
    }
    testMap.forEach((key, value) {
      if (value.length > 1) {
        if (kDebugMode) {
          print(warning("Warning: duplicate values, consider unifying keys"));
          print("keys: $value");
          print("value: $key");
        }
      }
    });
  }
}