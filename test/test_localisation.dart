import 'dart:io';
import 'package:battle_it_out/persistence/dao/profession_dao.dart';
import 'package:battle_it_out/persistence/dao/talent_dao.dart';
import 'package:battle_it_out/persistence/entities/profession.dart';
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

  for (var entry in languages.entries) {
    String languageName = entry.key;
    var translationMap = entry.value;

    group("Check language: $languageName", ()
    {
      test('Check talent localisations', () async {
        for (Talent talent in await TalentDAO().getAll()) {
          expect(translationMap.containsKey(talent.name), true, reason: "String not localised: ${talent.name}");
          if (talent.description != null) {
            expect(translationMap.containsKey(talent.description), true,
                reason: "String not localised: ${talent.description}");
          }
        }
      });
      test('Check profession class localisations', () async {
        for (ProfessionClass cls in await ProfessionClassDAO().getAll()) {
          expect(translationMap.containsKey(cls.name), true, reason: "String not localised: ${cls.name}");
        }
      });
      test('Check profession career localisations', () async {
        for (ProfessionCareer career in await ProfessionCareerDAO().getAll()) {
          expect(translationMap.containsKey(career.name), true, reason: "String not localised: ${career.name}");
        }
      });
      test('Check profession localisations', () async {
        for (Profession profession in await ProfessionDAO().getAll()) {
          expect(translationMap.containsKey(profession.name), true, reason: "String not localised: ${profession.name}");
        }
      });
      checkDuplicateValues(translationMap);
    });
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