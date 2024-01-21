import 'package:battle_it_out/entities_localisation.dart';
import 'package:battle_it_out/interface/components/race_library_item.dart';
import 'package:battle_it_out/interface/screens/edit_race_screen.dart';
import 'package:battle_it_out/persistence/ancestry.dart';
import 'package:battle_it_out/persistence/attribute.dart';
import 'package:battle_it_out/persistence/race.dart';
import 'package:battle_it_out/persistence/size.dart';
import 'package:battle_it_out/persistence/skill/skill.dart';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

class RaceLibraryWidget extends StatefulWidget {
  const RaceLibraryWidget({super.key});

  @override
  State<RaceLibraryWidget> createState() => _RaceLibraryWidgetState();
}

class _RaceLibraryWidgetState extends State<RaceLibraryWidget> {
  Map<Race, Tuple2<List<Ancestry>, List<Attribute>>> data = {};
  List<Size> sizes = [];
  List<Attribute> attributes = [];
  List<Skill> skills = [];

  Future<void> getAsyncData(BuildContext context) async {
    if (data.isEmpty) {
      List<Race> races = await RaceFactory().getAll();
      for (Race race in races) {
        List<Ancestry> ancestries = await AncestryFactory().getAncestryFromRace(race.id!);
        ancestries.sort((a, b) => a.name.localise(context).compareTo(b.name.localise(context)));
        List<Attribute> initialAttributes = await RaceFactory().getInitialAttributes(race);
        data[race] = Tuple2(ancestries, initialAttributes);
      }
    }

    // Get from DB
    if (sizes.isEmpty) sizes = await SizeFactory().getAll();
    if (attributes.isEmpty) attributes = await AttributeFactory().getAll();
    if (skills.isEmpty) skills = await SkillFactory().getAll();
  }

  List<MapEntry<Race, Tuple2<List<Ancestry>, List<Attribute>>>> getSortedData() {
    List<MapEntry<Race, Tuple2<List<Ancestry>, List<Attribute>>>> list = data.entries.toList();
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
              children: getSortedData().map((MapEntry<Race, Tuple2<List<Ancestry>, List<Attribute>>> entry) {
                return RaceLibraryItemWidget(
                    race: entry.key,
                    ancestries: entry.value.item1,
                    initialAttributes: entry.value.item2,
                    onLongPress: () {
                      Navigator.of(context)
                          .push<Tuple3<bool, Race?, List<Attribute>>>(
                        MaterialPageRoute(
                          builder: (context) => EditRaceScreen(
                            race: entry.key,
                            ancestries: entry.value.item1,
                            initialAttributes: entry.value.item2,
                            sizes: sizes,
                            attributes: attributes,
                            skills: skills,
                          ),
                        ),
                      )
                          .then((Tuple3<bool, Race?, List<Attribute>>? arguments) {
                        setState(() {
                          if (arguments!.item1) {
                            data.remove(entry.key);
                            if (arguments.item2 != null) {
                              data[arguments.item2!] = Tuple2(entry.value.item1, arguments.item3);
                            }
                          }
                        });
                      });
                    });
              }).toList(),
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
              Navigator.of(context)
                  .push<Tuple3<bool, Race?, List<Attribute>>>(
                MaterialPageRoute(
                    builder: (context) => EditRaceScreen(sizes: sizes, attributes: attributes, skills: skills)),
              )
                  .then((Tuple3<bool, Race?, List<Attribute>>? value) {
                setState(() {
                  if (value != null) {
                    data[value.item2!] = Tuple2([], value.item3);
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
