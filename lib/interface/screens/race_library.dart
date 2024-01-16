import 'package:battle_it_out/entities_localisation.dart';
import 'package:battle_it_out/interface/components/race_library_item.dart';
import 'package:battle_it_out/interface/screens/edit_race_screen.dart';
import 'package:battle_it_out/persistence/attribute.dart';
import 'package:battle_it_out/persistence/race.dart';
import 'package:battle_it_out/persistence/size.dart';
import 'package:battle_it_out/persistence/subrace.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class RaceLibraryWidget extends StatefulWidget {
  const RaceLibraryWidget({super.key});

  @override
  State<RaceLibraryWidget> createState() => _RaceLibraryWidgetState();
}

class _RaceLibraryWidgetState extends State<RaceLibraryWidget> {
  Map<Race, List<Subrace>> data = {};
  List<Size> sizes = [];
  List<Attribute> attributes = [];

  Future<void> getAsyncData(BuildContext context) async {
    if (data.isEmpty) {
      List<Race> races = await RaceFactory().getAll();
      for (Race race in races) {
        data[race] = await SubraceFactory().getSubracesFromRace(race.id!);
      }
    }

    // Get from DB
    if (sizes.isEmpty) sizes = await SizeFactory().getAll();
    if (attributes.isEmpty) attributes = await AttributeFactory().getAll();
  }

  List<MapEntry<Race, List<Subrace>>> getSortedData() {
    List<MapEntry<Race, List<Subrace>>> list = data.entries.toList();
    list.sort((a, b) => a.key.name.localise(context).compareTo(b.key.name.localise(context)));
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: getAsyncData(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.all(10.0),
              children: [
                ...getSortedData().mapIndexed(
                  (int i, MapEntry<Race, List<Subrace>> entry) => RaceLibraryItemWidget(
                    race: entry.key,
                    subraces: entry.value,
                    onLongPress: () {
                      Navigator.push<Race>(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditRaceScreen(race: entry.key, sizes: sizes, attributes: attributes),
                        ),
                      ).then((Race? value) {
                        setState(() {
                          data.remove(entry.key);
                          if (value != null) {
                            data[value] = entry.value;
                          }
                        });
                      });
                    },
                  ),
                ),
              ],
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "btn",
            child: const Icon(Icons.add),
            onPressed: () {
              Navigator.push<Race>(
                context,
                MaterialPageRoute(
                  builder: (context) => EditRaceScreen(sizes: sizes, attributes: attributes),
                ),
              ).then((Race? value) {
                setState(() {
                  if (value != null) {
                    data[value] = [];
                  }
                });
              });
            },
          )
        ],
      ),
    );
  }
}
