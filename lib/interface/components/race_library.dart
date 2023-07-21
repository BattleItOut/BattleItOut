import 'package:battle_it_out/entities_localisation.dart';
import 'package:battle_it_out/interface/components/forms/new_race_form.dart';
import 'package:battle_it_out/interface/components/list_items.dart';
import 'package:battle_it_out/localisation.dart';
import 'package:battle_it_out/persistence/race.dart';
import 'package:battle_it_out/persistence/subrace.dart';
import 'package:flutter/material.dart';

class RaceLibraryWidget extends StatefulWidget {
  const RaceLibraryWidget({super.key});

  @override
  State<RaceLibraryWidget> createState() => _RaceLibraryWidgetState();
}

class _RaceLibraryWidgetState extends State<RaceLibraryWidget> {
  final Map<Race, List<Subrace>> data = {};

  Future<void> getAsyncData(BuildContext context) async {
    List<Race> races = await RaceFactory().getAll();
    races.sort((a, b) => a.name.localise(context).compareTo(b.name.localise(context)));
    for (Race race in races) {
      data[race] = await SubraceFactory().getSubraces(race.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder(
        future: getAsyncData(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return ListView(shrinkWrap: true, padding: const EdgeInsets.all(10.0), children: [
              for (MapEntry<Race, List<Subrace>> entry in data.entries)
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(children: [
                    SizedBox(
                      width: 600.0,
                      child: TileListItem(
                        context: context,
                        child: ListTile(
                          title: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(7),
                              child: Text(
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                AppLocalizations.of(context).localise(entry.key.name),
                              ),
                            ),
                          ),
                          subtitle: Column(
                            children: [
                              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                for (var attribute in entry.key.initialAttributes.where((e) => e.importance == 0))
                                  Padding(
                                    padding: const EdgeInsets.all(7),
                                    child: Column(
                                      children: [
                                        Text(attribute.shortName.localise(context)),
                                        Text(attribute.base.toString()),
                                      ],
                                    ),
                                  ),
                              ]),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  for (var attribute in entry.key.initialAttributes.where((e) => e.importance == 1))
                                    Padding(
                                      padding: const EdgeInsets.all(7),
                                      child: Column(
                                        children: [
                                          Text(attribute.shortName.localise(context)),
                                          Text(attribute.base.toString()),
                                        ],
                                      ),
                                    ),
                                  Padding(
                                    padding: const EdgeInsets.all(7),
                                    child: Column(children: [
                                      Text("SIZE".localise(context)),
                                      Text(entry.key.size.name.localise(context)),
                                    ]),
                                  )
                                ],
                              ),
                            ],
                          ),
                          textColor: Theme.of(context).floatingActionButtonTheme.foregroundColor,
                          dense: true,
                          // trailing: IconButton(
                          //   icon: const Icon(Icons.add),
                          //   onPressed: () => showDialog(
                          //     context: context,
                          //     builder: (BuildContext context) => NewSubraceForm(entry.key),
                          //   ).then((_) => setState(() {})),
                          // ),
                        ),
                      ),
                    ),
                    Column(children: [
                      for (Subrace subrace in entry.value) Text(AppLocalizations.of(context).localise(subrace.name)),
                    ]),
                  ]),
                ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(children: [
                  TileListItem(
                    context: context,
                    child: SizedBox(
                      width: 200.0,
                      child: IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () => showDialog(
                          context: context,
                          builder: (BuildContext context) => const NewRaceForm(),
                        ).then((_) => setState(() {})),
                      ),
                    ),
                  ),
                ]),
              ),
            ]);
          }
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}
