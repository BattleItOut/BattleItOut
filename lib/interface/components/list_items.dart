import 'package:battle_it_out/entities_localisation.dart';
import 'package:battle_it_out/interface/components/padded_text.dart';
import 'package:battle_it_out/interface/components/table_line.dart';
import 'package:battle_it_out/persistence/character.dart';
import 'package:flutter/material.dart';

class ListItem extends Container {
  ListItem({Key? key, Widget? child, double? height, BoxDecoration? decoration})
      : super(key: key, margin: const EdgeInsets.all(4.0), height: height, decoration: decoration, child: child);
}

class ContainerWithTitle extends Container {
  ContainerWithTitle({Key? key, required Widget child})
      : super(key: key, child: child, margin: const EdgeInsets.all(8.0));

  static create({required Widget child, PaddedText? title, Key? key}) {
    List<Widget> widgets = [];
    if (title != null) {
      widgets.add(title);
      widgets.add(const Divider());
    }
    widgets.add(child);
    return ContainerWithTitle(child: Column(children: widgets), key: key);
  }
}

class LabelListItem extends ListItem {
  LabelListItem({Key? key, required String name}) : super(
      key: key,
      child: Center(child: Text(name)),
      height: 32
  );
}

class TileListItem extends ListItem {
  TileListItem({Key? key, Widget? child, required BuildContext context}) : super(
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
      subtitle: Text(character.race == null && character.profession == null ? "" : "${character.race?.name.localise(context) ?? ""}, ${character.profession?.name.localise(context) ?? ""}"),
      trailing: Text(character.initiative?.toString() ?? "", style: const TextStyle(fontSize: 24)),
      title: Text(character.name),
      dense: true,
      textColor: Theme.of(context).floatingActionButtonTheme.foregroundColor,
    ),
    context: context
  );
}

class GroupedEntitiesTable extends TileListItem {
  GroupedEntitiesTable({Function()? doOnLongPress, Key? key, PaddedText? title, required List<TableSubsection> children, required BuildContext context}) : super(
    key: key,
    child: InkWell(child: children.isEmpty ? const SizedBox.shrink() : ContainerWithTitle.create(
      title: title,
      child: createTable(children)),
    onLongPress: doOnLongPress),
    context: context
  );

  static Widget createTable(List<TableSubsection> children) {
    children.sort((a, b) => a.header!.children[0].text.compareTo(b.header!.children[0].text));
    return Table(
      columnWidths: {for (var i = 0; i < children[0].children[0].children.length; i++) i: children[0].children[0].children[i].columnWidth},
      children: [for (var row in children) row.create()].expand((x) => x).toList());
  }
}

class SingleEntitiesTable extends GroupedEntitiesTable {
  SingleEntitiesTable({Key? key, PaddedText? title, required List<TableLine> children, required BuildContext context}) :
        super(title: title, key: key, children: children.isEmpty ? [] : [TableSubsection(children: children)], context: context);
}

extension ItemList on List<dynamic> {
  void rotateLeft() {
    dynamic first = this[0];
    int i;
    for (i = 0; i < length - 1; i++) {
      this[i] = this[i + 1];
    }
    this[i] = first;
  }

  void rotateRight() {
    dynamic last = this[length - 1];
    for (int i = length - 2; i >= 0; i--) {
      this[i + 1] = this[i];
    }
    this[0] = last;
  }
}
