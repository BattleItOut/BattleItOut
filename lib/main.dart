import 'package:flutter/material.dart';

import 'DTO/talent.dart';
import 'database_connection.dart';
import 'interface/screens/turn_order_screen.dart';

void main() async {
  runApp(const MyApp());
  WFRPDatabase database = await WFRPDatabase.create("assets/database/database.sqlite");
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
