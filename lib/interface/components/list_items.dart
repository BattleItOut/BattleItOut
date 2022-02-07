import 'package:battle_it_out/persistence/character.dart';
import 'package:flutter/material.dart';

class ListItem extends Container {
  ListItem({
    Key? key,
    required Widget child,
    double? height,
    BoxDecoration? decoration
  }) : super(
      key: key,
      margin: const EdgeInsets.all(4.0),
      height: height,
      decoration: decoration,
      child: child
  );
}

class LabelListItem extends ListItem {
  LabelListItem({Key? key, required String name}) : super(
      key: key,
      child: Center(child: Text(name)),
      height: 32
  );
}

class CharacterListItem extends ListItem {
  CharacterListItem({Key? key, required Character character, required BuildContext context}) : super(
    key: key,
    child: ListTile(
      subtitle: Text("${character.race.name}, ${character.profession.name}"),
      trailing: Text(character.initiative?.toString() ?? "", style: const TextStyle(fontSize: 24)),
      title: Text(character.name),
      dense: true,
    ),
    decoration: BoxDecoration(
      borderRadius: const BorderRadius.all(Radius.circular(8.0)),
      color: Theme.of(context).primaryColor
    ),
  );
}

extension ItemList on List<dynamic> {
  void rotateLeft() {
    dynamic first = this[0];
    int i;
    for (i = 0; i < length - 1; i++) {
      this[i] = this[i+1];
    }
    this[i] = first;
  }
}