import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:yaml/yaml.dart';

class AppLocalizations {
  final Locale locale;
  static Map<String, Map<String, String>> _localizedValues = {};

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static List<String> get languages => _localizedValues.keys.toList();

  String localise(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? key;
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  static const supportedLocales = [
    Locale('en', ''),
    Locale('pl', ''),
  ];

  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return supportedLocales.contains(locale);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    AppLocalizations._localizedValues = await loadYML();
    return AppLocalizations(locale);
  }

  static Future<Map<String, Map<String, String>>> loadYML() async {
    Map<String, Map<String, String>> localizedValues = {};
    await for (var file in Directory("assets/database/localisation").list(followLinks: false)) {
      String filePath = file.path;
      if (filePath.endsWith(".yml")) {
        YamlMap ymlMap = loadYaml(await File(filePath).readAsString());
        String language = ymlMap.keys.first;
        if (!localizedValues.containsKey(language)) {
          localizedValues[language] = {};
        }
        for (var entry in ymlMap[language].entries) {
          localizedValues[language]![entry.key] = entry.value;
        }
      }
    }
    return localizedValues;
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}