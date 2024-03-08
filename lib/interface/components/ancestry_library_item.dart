import 'package:battle_it_out/entities_localisation.dart';
import 'package:battle_it_out/interface/components/list_items.dart';
import 'package:battle_it_out/persistence/ancestry.dart';
import 'package:flutter/material.dart';

class AncestryLibraryItemWidget extends StatelessWidget {
  final Ancestry ancestry;
  final void Function()? onTap;
  final void Function()? onLongPress;

  const AncestryLibraryItemWidget({super.key, required this.ancestry, this.onTap, this.onLongPress});

  @override
  Widget build(BuildContext context) {
    return ListItem(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(8.0)),
        color: Theme.of(context).primaryColor,
      ),
      child: ListTile(
        title: Column(children: [
          Padding(
            padding: const EdgeInsets.all(7),
            child: Column(children: [
              Text(
                ancestry.name.localise(context),
                style: const TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
              )
            ]),
          ),
        ]),
        onTap: onTap,
        onLongPress: onLongPress,
        textColor: Theme.of(context).floatingActionButtonTheme.foregroundColor,
        dense: true,
      ),
    );
  }
}
