import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:yaml/yaml.dart';

class LocalisationManager {
  String? _currentLanguage;
  bool _loaded = false;
  final Map<String, Map<String, String>> _languages = {};
  static final LocalisationManager _instance = LocalisationManager._();

  LocalisationManager._();
  static LocalisationManager get instance => _instance;

  String _warning(String text) {
    return '\x1B[33m$text\x1B[0m';
  }

  Future<void> load() async {
    await for (var file in Directory("assets/database/localisation").list(followLinks: false)) {
      String filePath = file.path;
      if (filePath.endsWith(".yml")) {
        YamlMap ymlMap = loadYaml(await File(filePath).readAsString());
        String language = ymlMap.keys.first;
        if (!_languages.containsKey(language)) {
          _languages[language] = {};
        }
        for (var entry in ymlMap[language].entries) {
          _languages[language]![entry.key] = entry.value;
        }
      }
    }
    if (kDebugMode) {
      print("Localisation loaded");
    }
    _loaded=true;
  }
  void setLanguage(String language) async {
    if (!_loaded) {
      await load();
    }
    if (!_languages.containsKey(language)) {
      if (kDebugMode) {
        print("Language $_currentLanguage not supported");
      }
    } else {
      _currentLanguage = language;
    }
  }
  void resetLanguage() {
    _currentLanguage = null;
  }

  Future<List<String>> getPossibleLanguages() async {
    if (!_loaded) {
      await load();
    }
    return _languages.keys.toList();
  }

  bool check(String key, [String? language]) {
    return _languages[language ?? _currentLanguage]?.containsKey(key) ?? false;
  }

  String localise(String key, [String? language]) {
    return _languages[language ?? _currentLanguage]?[key] ?? key;
  }

  void duplicateValuesTest() {
    if (_currentLanguage == null) {
      return;
    }

    var testMap = {};
    for (var entry in _languages[_currentLanguage]!.entries) {
      if (testMap.containsKey(entry.value)) {
        testMap[entry.value].add(entry.key);
      } else {
        testMap[entry.value] = [];
      }
    }
    testMap.forEach((key, value) {
      if (value.length > 1) {
        if (kDebugMode) {
          print(_warning("Warning: duplicate values, consider unifying keys"));
          print("keys: $value");
          print("value: $key");
        }
      }
    });
  }
}