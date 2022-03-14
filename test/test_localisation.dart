import 'package:battle_it_out/localisation_manager.dart';
import 'package:battle_it_out/persistence/dao/armour_dao.dart';
import 'package:battle_it_out/persistence/dao/attribute_dao.dart';
import 'package:battle_it_out/persistence/dao/profession_dao.dart';
import 'package:battle_it_out/persistence/dao/race_dao.dart';
import 'package:battle_it_out/persistence/dao/size_dao.dart';
import 'package:battle_it_out/persistence/dao/skill_dao.dart';
import 'package:battle_it_out/persistence/dao/talent_dao.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> localisationTest() async {
  List<String> languages = await LocalisationManager.instance.getPossibleLanguages();
  group("Check localisations", () {
    test("LocalisationManager test", () {
      LocalisationManager.instance.resetLanguage();
      expect(LocalisationManager.instance.localise("SMALL"), "SMALL");
      LocalisationManager.instance.setLanguage("POLISH");
      expect(LocalisationManager.instance.localise("SMALL"), "Mały");
      expect(LocalisationManager.instance.localise("SMALL", "ENGLISH"), "Small");
      expect(LocalisationManager.instance.localise("SMALL", "NULL"), "SMALL");
      LocalisationManager.instance.resetLanguage();
    });

    for (String languageName in languages) {
      group("Check language: $languageName", () {
        void performLocTest(name, var dao, var getter) {
          test(name, () async {
            for (var item in await dao.getAll()) {
              for (var param in getter(item)) {
                if (param != null) {
                  expect(LocalisationManager.instance.check(param, languageName), true, reason: "String not localised: $param");
                }
              }
            }
          });
        }

        performLocTest("Check base talent localisations", BaseTalentDAO(), (item) => [item.name, item.description]);
        performLocTest("Check talent localisations", TalentDAO(), (item) => [item.name]);
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

        // checkDuplicateValues(translationMap);
      });
    }
  });
}