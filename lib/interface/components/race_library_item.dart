import 'package:battle_it_out/entities_localisation.dart';
import 'package:battle_it_out/interface/components/list_items.dart';
import 'package:battle_it_out/localisation.dart';
import 'package:battle_it_out/persistence/ancestry.dart';
import 'package:battle_it_out/persistence/attribute.dart';
import 'package:battle_it_out/persistence/race.dart';
import 'package:flutter/material.dart';

class RaceLibraryItemWidget extends StatelessWidget {
  final Race race;
  final void Function()? onTap;
  final void Function()? onLongPress;

  const RaceLibraryItemWidget({super.key, required this.race, this.onTap, this.onLongPress});

  @override
  Widget build(BuildContext context) {
    return ListItem(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(8.0)),
        color: Theme.of(context).primaryColor,
      ),
      child: ListTile(
        title: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(7),
              child: Text(
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                race.name.localise(context),
              ),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              for (Attribute attribute in race.attributes.where((e) => e.importance == 0))
                Padding(
                  padding: const EdgeInsets.all(7),
                  child: Column(
                    children: [
                      Text(AppLocalizations.of(context).localise(attribute.shortName)),
                      Text(attribute.base.toString()),
                    ],
                  ),
                ),
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              for (var attribute in race.attributes.where((e) => e.importance == 1))
                Padding(
                  padding: const EdgeInsets.all(7),
                  child: Column(
                    children: [
                      Text(AppLocalizations.of(context).localise(attribute.shortName)),
                      Text(attribute.base.toString()),
                    ],
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(7),
                child: Column(children: [
                  Text("SIZE".localise(context)),
                  Text(race.size.name.localise(context)),
                ]),
              )
            ]),
          ],
        ),
        subtitle: Column(children: [
          for (Ancestry ancestry in race.ancestries)
            Padding(
              padding: const EdgeInsets.all(7),
              child: Column(children: [
                race.ancestries.length != 1
                    ? Text(ancestry.name.localise(context),
                        style: const TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic))
                    : const SizedBox.shrink(),
              ]),
            )
        ]),
        onTap: onTap,
        onLongPress: onLongPress,
        textColor: Theme.of(context).floatingActionButtonTheme.foregroundColor,
        dense: true,
      ),
    );
  }
}
