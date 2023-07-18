import 'package:battle_it_out/persistence/race.dart';
import 'package:flutter/material.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({Key? key}) : super(key: key);

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Library"),
      ),
      body: const RaceLibrary(),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // Fixed
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.black,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.accessibility), label: "Races"),
          BottomNavigationBarItem(icon: Icon(Icons.replay), label: "Turn Order"),
          BottomNavigationBarItem(icon: Icon(Icons.description), label: "Character Sheets")
        ],
      ),
    );
  }
}

class RaceLibrary extends StatelessWidget {
  const RaceLibrary({super.key});

  Future<List<Race>> generateRace() async {
    return await RaceFactory().getAll();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Center(
          child: FutureBuilder<List<Race>>(
            future: generateRace(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Column(children: [for (Race race in snapshot.data!)
                  Text(race.name)
                ]);
              }
              return const CircularProgressIndicator();
            },
          ),
        ),
      ],
    );
  }
}
