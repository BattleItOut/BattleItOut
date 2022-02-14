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

class TileListItem extends ListItem {
  TileListItem({Key? key, required Widget child, required BuildContext context}) : super(
    key: key,
    child: child,
    decoration: BoxDecoration(
      borderRadius: const BorderRadius.all(Radius.circular(8.0)),
      color: Theme.of(context).primaryColor
    ),
  );
}

class CharacterListItem extends TileListItem {
  CharacterListItem({Key? key, required Character character, required BuildContext context}) : super(
    key: key,
    child: ListTile(
      subtitle: Text("${character.race.name}, ${character.profession.name}"),
      trailing: Text(character.initiative?.toString() ?? "", style: const TextStyle(fontSize: 24)),
      title: Text(character.name),
      dense: true,
      textColor: Theme.of(context).floatingActionButtonTheme.foregroundColor,
    ),
    context: context
  );
}

class CharacteristicListItem extends TileListItem {
  CharacteristicListItem({
    Key? key,
    String? title,
    required List<List<String>> child,
    required BuildContext context,
    bool isVertical = true
  }) : super(
    key: key,
    child: Container(
      margin: const EdgeInsets.all(8.0),
      child: title != null ? Column(
        children: [
          Text(title, style: const TextStyle(fontSize: 24.0)),
          Table(
            children: [
              for (var row in child) TableRow(
                children: [for (var value in row) Text(value)]
              )
            ],
          )
        ],
      ) : Table(
        children: [
          for (var row in child) TableRow(
            children: [for (var value in row) Text(value)]
          )
        ],
      )
    ),
    context: context
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

  void rotateRight() {
    dynamic last = this[length - 1];
    for (int i = length - 2; i >= 0; i--) {
      this[i+1] = this[i];
    }
    this[0] = last;
  }
}