import 'package:battle_it_out/persistence/character.dart';
import 'package:battle_it_out/persistence/wfrp_database.dart';
import 'package:flutter/material.dart';

import 'persistence/DTO/talent.dart';
import 'interface/screens/turn_order_screen.dart';

void main() async {
  runApp(const MyApp());
  WFRPDatabase database = await WFRPDatabase.create("assets/database/database.sqlite");
  Character char = await Character.create("assets/character.json", database);
  List<Talent> list = await database.getTalents();
  for (Talent talent in list) {
    if (!talent.isGrouped()) {
      print(talent);
    }
  }
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
