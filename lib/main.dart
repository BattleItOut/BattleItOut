import 'dart:convert';

import 'package:battle_it_out/app_cache.dart';
import 'package:battle_it_out/interface/themes.dart';
import 'package:battle_it_out/interface/screens/turn_order_screen.dart';
import 'package:battle_it_out/persistence/character.dart';
import 'package:battle_it_out/persistence/wfrp_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  runApp(const MyApp());

  List<Character> templateCharacters = await loadTemplates();
  AppCache.init(characters: templateCharacters);
}

Future<List<Character>> loadTemplates() async {
  final manifestJson = await rootBundle.loadString('AssetManifest.json');
  final templates = json.decode(manifestJson).keys.where((String key) => key.startsWith('assets/templates'));

  List<Character> templateCharacters = [];
  for (var template in templates) {
    Character character = await Character.create(template);
    templateCharacters.add(character);
  }
  return templateCharacters;
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BattleItOut',
      themeMode: ThemeMode.system,
      theme: Themes.lightTheme,
      darkTheme: Themes.darkTheme,
      home: const TurnOrderScreen(),
    );
  }
}
