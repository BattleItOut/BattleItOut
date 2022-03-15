import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    final manifestJson = await rootBundle.loadString('AssetManifest.json');
    for (var filePath in json.decode(manifestJson).keys) {
      if (filePath.startsWith('assets/database/localisation') && filePath.endsWith(".yml")) {
        YamlMap ymlMap = loadYaml(await rootBundle.loadString(filePath));
        String language = ymlMap.keys.first;
        if (!localizedValues.containsKey(language)) {
          localizedValues[language] = {};
        }
        for (var entry in ymlMap[language].entries) {
          if (!localizedValues[language]!.containsKey(entry.key)) {
            localizedValues[language]![entry.key] = entry.value;
          } else {
            throw Exception("Duplicated key [${entry.key}, ${localizedValues[language]![entry.key]}], [${entry.key}, ${entry.value}]");
          }
        }
      }
    }
    return localizedValues;
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}