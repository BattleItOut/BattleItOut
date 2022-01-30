import 'dart:convert';

import 'package:battle_it_out/app_cache.dart';
import 'package:battle_it_out/persistence/character.dart';
import 'package:battle_it_out/persistence/wfrp_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'interface/screens/turn_order_screen.dart';

void main() async {
  runApp(const MyApp());
  WFRPDatabase database = await WFRPDatabase.create("assets/database/database.sqlite");

  List<Character> templateCharacters = await loadTemplates(database);
  AppCache.init(characters: templateCharacters);
}

Future<List<Character>> loadTemplates(WFRPDatabase database) async {
  final manifestJson = await rootBundle.loadString('AssetManifest.json');
  final templates = json.decode(manifestJson).keys.where((String key) => key.startsWith('assets/templates'));

  List<Character> templateCharacters = [];
  for (var template in templates) {
    Character character = await Character.create(template, database);
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
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const TurnOrderScreen(title: 'Turn Order'),
    );
  }
}
