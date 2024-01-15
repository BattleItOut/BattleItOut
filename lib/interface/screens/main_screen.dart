import 'package:battle_it_out/interface/screens/character_sheets_library.dart';
import 'package:battle_it_out/interface/screens/library_screen.dart';
import 'package:battle_it_out/interface/screens/turn_order_screen.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  static final log = Logger('MainScreen');

  void _onNavigationTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        Navigator.push(context, MaterialPageRoute(builder: (context) => const LibraryScreen()));
        break;
      case 1:
        Navigator.push(context, MaterialPageRoute(builder: (context) => const TurnOrderScreen()));
        break;
      case 2:
        Navigator.push(context, MaterialPageRoute(builder: (context) => const CharacterSheetsLibrary()));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("BattleItOut"),
      ),
      body: const Center(),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.photo_library), label: "Library"),
          BottomNavigationBarItem(icon: Icon(Icons.replay), label: "Turn Order"),
          BottomNavigationBarItem(icon: Icon(Icons.description), label: "Character Sheets")
        ],
        onTap: (index) => _onNavigationTapped(index, context),
      ),
    );
  }
}
