import 'package:battle_it_out/entities_localisation.dart';
import 'package:battle_it_out/interface/components/forms/new_race_form.dart';
import 'package:battle_it_out/interface/components/list_items.dart';
import 'package:battle_it_out/interface/components/race_library_item.dart';
import 'package:battle_it_out/interface/screens/edit_race_screen.dart';
import 'package:battle_it_out/persistence/race.dart';
import 'package:battle_it_out/persistence/size.dart';
import 'package:battle_it_out/persistence/subrace.dart';
import 'package:flutter/material.dart';

class RaceLibraryWidget extends StatefulWidget {
  const RaceLibraryWidget({super.key});

  @override
  State<RaceLibraryWidget> createState() => _RaceLibraryWidgetState();
}

class _RaceLibraryWidgetState extends State<RaceLibraryWidget> {
  final Map<Race, List<Subrace>> data = {};
  List<Size> sizes = [];

  Future<void> getAsyncData(BuildContext context) async {
    List<Race> races = await RaceFactory().getAll();
    races.sort((a, b) => a.name.localise(context).compareTo(b.name.localise(context)));
    for (Race race in races) {
      data[race] = await SubraceFactory().getSubracesFromRace(race.id!);
    }

    // Sizes
    sizes = await SizeFactory().getAll();
  }

  List<MapEntry<Race, List<Subrace>>> getSortedData() {
    List<MapEntry<Race, List<Subrace>>> list = data.entries.toList();
    list.sort((a, b) => a.key.name.localise(context).compareTo(b.key.name.localise(context)));
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getAsyncData(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.all(10.0),
            children: [
              for (MapEntry<Race, List<Subrace>> entry in getSortedData())
                RaceLibraryItemWidget(
                  race: entry.key,
                  subraces: entry.value,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EditRaceScreen(race: entry.key)),
                    );
                  },
                ),
              ListItem(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                  color: Theme.of(context).primaryColor,
                ),
                child: ListTile(
                  title: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(7),
                      child: Text(
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        "NEW_RACE".localise(context),
                      ),
                    ),
                  ),
                  subtitle: IconButton(
                    icon: const Icon(Icons.add, color: Colors.white),
                    onPressed: () => showDialog<Race>(
                      context: context,
                      builder: (BuildContext context) => NewRaceForm(sizes),
                    ).then((Race? race) {
                      if (race != null) {
                        setState(() => data[race] = []);
                      }
                    }),
                  ),
                  onLongPress: () => {},
                  textColor: Theme.of(context).floatingActionButtonTheme.foregroundColor,
                  dense: true,
                ),
              ),
            ],
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
