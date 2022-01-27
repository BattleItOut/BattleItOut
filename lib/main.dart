import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import 'DTO/talent.dart';
import 'database_connection.dart';
import 'my_home_page.dart';

void main() async {
  runApp(const MyApp());
  final Database database = await dbConnect("assets/database/database.sqlite");
  List<Talent> list = await getTalents(database);
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
      home: const MyHomePage(title: 'Turn Order'),
    );
  }
}
