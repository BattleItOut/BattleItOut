import 'package:battle_it_out/interface/screens/race_library.dart';
import 'package:battle_it_out/interface/screens/skill_library.dart';
import 'package:flutter/material.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  List<Widget> screens = const [RaceLibrary(), SizedBox(), SkillLibrary(), SizedBox(), SizedBox()];
  int activeScreenId = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Library"),
      ),
      body: screens[activeScreenId],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.black,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.accessibility), label: "Races"),
          BottomNavigationBarItem(icon: Icon(Icons.work), label: "Professions"),
          BottomNavigationBarItem(icon: Icon(Icons.arrow_upward), label: "Skills"),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: "Talents"),
          BottomNavigationBarItem(icon: Icon(Icons.now_wallpaper), label: "Items")
        ],
        onTap: (index) => setState(() => activeScreenId = index),
        currentIndex: activeScreenId,
      ),
    );
  }
}
