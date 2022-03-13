import 'dart:io';
import 'package:battle_it_out/persistence/dao/profession_dao.dart';
import 'package:battle_it_out/persistence/dao/race_dao.dart';
import 'package:battle_it_out/persistence/dao/size_dao.dart';
import 'package:battle_it_out/persistence/dao/talent_dao.dart';
import 'package:battle_it_out/persistence/entities/talent.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yaml/yaml.dart';

Future<void> localisationTest() async {
  Map<String, YamlMap> languages = {};
  await for (var file in Directory("assets/database/localisation").list(followLinks: false)) {
    String filePath = file.path;
    if (filePath.endsWith(".yml")) {
      YamlMap ymlMap = loadYaml(await File(filePath).readAsString());
      languages.putIfAbsent(ymlMap.keys.first, () => ymlMap[ymlMap.keys.first]);
    }
  }

  group("Check localisations", () {
    for (var entry in languages.entries) {
      String languageName = entry.key;
      var translationMap = entry.value;
      group("Check language: $languageName", ()
      {
        test('Check base talent localisations', () async {
          for (BaseTalent talent in await BaseTalentDAO().getAll()) {
            expect(translationMap.containsKey(talent.name), true, reason: "String not localised: ${talent.name}");
            expect(translationMap.containsKey(talent.description), true,
                reason: "String not localised: ${talent.description}");
          }
        });
        performLocalisationTest("Check talent localisations", translationMap, TalentDAO());
        performLocalisationTest("Check profession class localisations", translationMap, ProfessionCareerDAO());
        performLocalisationTest("Check profession career localisations", translationMap, ProfessionCareerDAO());
        performLocalisationTest("Check profession localisations", translationMap, ProfessionDAO());
        performLocalisationTest("Check race localisations", translationMap, RaceDAO());
        performLocalisationTest("Check subrace localisations", translationMap, SubraceDAO());
        performLocalisationTest("Check size localisations", translationMap, SizeDao());

        checkDuplicateValues(translationMap);
      });
    }
  });
}

void performLocalisationTest(name, translationMap, var dao) {
  test(name, () async {
    for (var item in await dao.getAll()) {
      expect(translationMap.containsKey(item.name), true, reason: "String not localised: ${item.name}");
    }
  });
}

void checkUnusedKeys(YamlMap translationMap, List<String> usedLocalisations) {
  for (var entry in translationMap.entries) {
    if (!usedLocalisations.contains(entry.key)) {
      if (kDebugMode) {
        print(warning("Warning, unused key: ${entry.key}, consider deleting"));
      }
    }
  }
}

void checkDuplicateValues(YamlMap translationMap) {
  var testMap = {};
  for (var entry in translationMap.entries) {
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

String warning(String text) {
  return '\x1B[33m$text\x1B[0m';
}