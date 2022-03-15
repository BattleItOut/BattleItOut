import 'package:battle_it_out/localisation.dart';
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
      subtitle: Text("${AppLocalizations.of(context).localise(character.race.name)}, ${AppLocalizations.of(context).localise(character.profession.name)}"),
      trailing: Text(character.initiative?.toString() ?? "", style: const TextStyle(fontSize: 24)),
      title: Text(character.name),
      dense: true,
      textColor: Theme.of(context).floatingActionButtonTheme.foregroundColor,
    ),
    context: context
  );
}

enum CharacteristicType { name, shortcut, value }

class CharacteristicListItem extends TileListItem {
  CharacteristicListItem({
    Key? key,
    String? title,
    required List<List<String>> children,
    List<CharacteristicType?>? columnTypes,
    required BuildContext context
  }) : super(
    key: key,
    child: Container(
      margin: const EdgeInsets.all(8.0),
      child: title != null ? Column(
        children: [
          Text(title, style: const TextStyle(fontSize: 24.0)),
          const Divider(),
          CharacteristicListItem.createTable(children, columnTypes)
        ],
      ) : CharacteristicListItem.createTable(children, columnTypes)
    ),
    context: context
  );

  static Widget createTable(List<List<String>> children, List<CharacteristicType?>? columnTypes) {
    TableColumnWidth characteristicTypeToTableColumnWidth(CharacteristicType? type) {
      switch (type) {
        case null: return const FlexColumnWidth();
        case CharacteristicType.name: return const FlexColumnWidth();
        case CharacteristicType.shortcut: return const FixedColumnWidth(48);
        case CharacteristicType.value: return const FixedColumnWidth(32);
      }
    }

    TextAlign characteristicTypeToTextAlign(CharacteristicType? type) {
      switch (type) {
        case null: return TextAlign.center;
        case CharacteristicType.name: return TextAlign.left;
        case CharacteristicType.shortcut: return TextAlign.center;
        case CharacteristicType.value: return TextAlign.center;
      }
    }

    if (children.isEmpty) return const SizedBox.shrink();

    if (columnTypes != null) {
      assert(children[0].length == columnTypes.length);
    } else {
      columnTypes = List.filled(children[0].length, null);
    }

    return Table(
      columnWidths: {
        for (var i = 0; i < columnTypes.length; i++) i: characteristicTypeToTableColumnWidth(columnTypes[i]),
      },
      children: [
        for (var row in children) TableRow(
          children: [for (var value in row.asMap().entries) Text(
            value.value,
            textAlign: characteristicTypeToTextAlign(columnTypes[value.key])
          )]
        )
      ],
    );
  }
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