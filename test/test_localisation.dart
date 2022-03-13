import 'dart:io';
import 'package:battle_it_out/persistence/dao/profession_dao.dart';
import 'package:battle_it_out/persistence/dao/race_dao.dart';
import 'package:battle_it_out/persistence/dao/size_dao.dart';
import 'package:battle_it_out/persistence/dao/talent_dao.dart';
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
      group("Check language: $languageName", () {
        void performLocalisationTest(name, var dao, var getter) {
          test(name, () async {
            for (var item in await dao.getAll()) {
              for (var param in getter(item)) {
                expect(translationMap.containsKey(param), true, reason: "String not localised: $param");
              }
            }
          });
        }

        performLocalisationTest("Check base talent localisations", BaseTalentDAO(), (item) => [item.name, item.description]);
        performLocalisationTest("Check talent localisations", TalentDAO(), (item) => [item.name]);
        performLocalisationTest("Check profession class localisations", ProfessionCareerDAO(), (item) => [item.name]);
        performLocalisationTest("Check profession career localisations", ProfessionCareerDAO(), (item) => [item.name]);
        performLocalisationTest("Check profession localisations", ProfessionDAO(), (item) => [item.name]);
        performLocalisationTest("Check race localisations", RaceDAO(), (item) => [item.name]);
        performLocalisationTest("Check subrace localisations", SubraceDAO(), (item) => [item.name]);
        performLocalisationTest("Check size localisations", SizeDao(), (item) => [item.name]);

        checkDuplicateValues(translationMap);
      });
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
