import 'package:battle_it_out/interface/components/async_consumer.dart';
import 'package:battle_it_out/interface/components/race_library_item.dart';
import 'package:battle_it_out/interface/screens/edit_race_screen.dart';
import 'package:battle_it_out/persistence/race.dart';
import 'package:battle_it_out/providers/race_provider.dart';
import 'package:flutter/material.dart';

class RaceLibrary extends StatelessWidget {
  const RaceLibrary({super.key});

  Future<void> getAsyncData(RaceProvider provider) async {
    for (Race race in provider.items) {
      await race.ancestries.getAsync();
      await race.attributes.getAsync();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AsyncConsumer<RaceProvider>(
        future: (RaceProvider provider) => getAsyncData(provider),
        builder: (RaceProvider provider) => ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(10.0),
          children: [
            for (Race race in provider.items)
              RaceLibraryItemWidget(
                race: race,
                onLongPress: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditRaceScreen(race: race)));
                },
              )
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "btn",
            child: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const EditRaceScreen()));
            },
          )
        ],
      ),
    );
  }

  ListView buildListView(RaceProvider provider, BuildContext context) {
    return ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.all(10.0),
      children: [
        for (Race race in provider.items)
          RaceLibraryItemWidget(
            race: race,
            onLongPress: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditRaceScreen(race: race)));
            },
          )
      ],
    );
  }
}
