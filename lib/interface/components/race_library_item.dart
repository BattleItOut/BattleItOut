import 'package:battle_it_out/entities_localisation.dart';
import 'package:battle_it_out/interface/components/list_items.dart';
import 'package:battle_it_out/persistence/attribute.dart';
import 'package:battle_it_out/persistence/race.dart';
import 'package:battle_it_out/persistence/subrace.dart';
import 'package:flutter/material.dart';

class RaceLibraryItemWidget extends StatefulWidget {
  final Race race;
  final List<Attribute> initialAttributes;
  final List<Subrace> subraces;
  final void Function()? onTap;
  final void Function()? onLongPress;

  const RaceLibraryItemWidget(
      {super.key,
      required this.race,
      required this.subraces,
      required this.initialAttributes,
      this.onTap,
      this.onLongPress});

  @override
  State<RaceLibraryItemWidget> createState() => _RaceLibraryItemWidgetState();
}

class _RaceLibraryItemWidgetState extends State<RaceLibraryItemWidget> {
  List<Subrace> subraces = [];

  @override
  void initState() {
    super.initState();
    subraces = widget.subraces;
  }

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
                widget.race.name.localise(context),
              ),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              for (var attribute in widget.initialAttributes.where((e) => e.importance == 0))
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
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              for (var attribute in widget.initialAttributes.where((e) => e.importance == 1))
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
                  Text(widget.race.size.name.localise(context)),
                ]),
              )
            ]),
          ],
        ),
        subtitle: Column(children: [
          for (Subrace subrace in subraces)
            Padding(
              padding: const EdgeInsets.all(7),
              child: Column(children: [
                subraces.length != 1
                    ? Text(
                        subrace.name.localise(context),
                        style: const TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
                      )
                    : const SizedBox.shrink(),
              ]),
            )
        ]),
        onTap: widget.onTap,
        onLongPress: widget.onLongPress,
        textColor: Theme.of(context).floatingActionButtonTheme.foregroundColor,
        dense: true,
      ),
    );
  }
}
