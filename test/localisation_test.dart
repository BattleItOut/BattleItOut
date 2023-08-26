import 'package:battle_it_out/localisation.dart';
import 'package:battle_it_out/persistence/attribute.dart';
import 'package:battle_it_out/persistence/item/ammunition.dart';
import 'package:battle_it_out/persistence/item/armour.dart';
import 'package:battle_it_out/persistence/item/item_quality.dart';
import 'package:battle_it_out/persistence/item/melee_weapon.dart';
import 'package:battle_it_out/persistence/item/ranged_weapon.dart';
import 'package:battle_it_out/persistence/item/weapon_length.dart';
import 'package:battle_it_out/persistence/profession/profession.dart';
import 'package:battle_it_out/persistence/profession/profession_career.dart';
import 'package:battle_it_out/persistence/profession/profession_class.dart';
import 'package:battle_it_out/persistence/race.dart';
import 'package:battle_it_out/persistence/size.dart';
import 'package:battle_it_out/persistence/skill/skill.dart';
import 'package:battle_it_out/persistence/skill/skill_base.dart';
import 'package:battle_it_out/persistence/subrace.dart';
import 'package:battle_it_out/persistence/talent/talent.dart';
import 'package:battle_it_out/persistence/talent/talent_base.dart';
import 'package:battle_it_out/persistence/talent/talent_test.dart';
import 'package:battle_it_out/persistence/trait.dart';
import 'package:battle_it_out/utils/database_provider.dart';
import 'package:battle_it_out/utils/utilities.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await DatabaseProvider.instance.connect(test: true);

  var languages = await AppLocalizationsDelegate.loadYML();
  for (var entry in languages.entries) {
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

      performLocTest("Check npc traits localisations", TraitFactory(), (item) => [item.name, item.description]);
      performLocTest("Check base talent localisations", BaseTalentFactory(), (item) => [item.name, item.description]);
      performLocTest("Check talent localisations", TalentFactory(), (item) => [item.name, item.specialisation]);
      performLocTest("Check talent test localisations", TalentTestFactory(), (item) => [item.comment]);
      performLocTest("Check profession class localisations", ProfessionClassFactory(), (item) => [item.name]);
      performLocTest("Check profession career localisations", ProfessionCareerFactory(), (item) => [item.name]);
      performLocTest("Check profession localisations", ProfessionFactory(), (item) => [item.name]);
      performLocTest("Check race localisations", RaceFactory(), (item) => [item.name]);
      performLocTest("Check subrace localisations", SubraceFactory(), (item) => [item.name]);
      performLocTest("Check size localisations", SizeFactory(), (item) => [item.name]);
      performLocTest("Check armour localisations", ArmourFactory(), (item) => [item.name]);
      performLocTest(
          "Check attribute localisations", AttributeFactory(), (item) => [item.name, item.shortName, item.description]);
      performLocTest("Check base skill localisations", BaseSkillFactory(), (item) => [item.name, item.description]);
      performLocTest("Check skill localisations", SkillFactory(), (item) => [item.name, item.specialisation]);
      performLocTest(
          "Check weapon length localisations", WeaponLengthFactory(), (item) => [item.name, item.description]);
      performLocTest("Check melee weapon localisations", MeleeWeaponFactory(), (item) => [item.name]);
      performLocTest("Check ranged weapon localisations", RangedWeaponFactory(), (item) => [item.name]);
      performLocTest("Check ranged weapon ammo localisations", AmmunitionFactory(), (item) => [item.name]);
      performLocTest("Check item quality localisations", ItemQualityFactory(), (item) => [item.name, item.description]);
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
