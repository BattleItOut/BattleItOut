import 'package:battle_it_out/entities_localisation.dart';
import 'package:battle_it_out/interface/components/padded_text.dart';
import 'package:battle_it_out/interface/components/table_line.dart';
import 'package:battle_it_out/persistence/character.dart';
import 'package:flutter/material.dart';

class ListItem extends Container {
  ListItem({super.key, super.child, super.height, BoxDecoration? super.decoration})
      : super(margin: const EdgeInsets.all(4.0));
}

class ContainerWithTitle extends Container {
  ContainerWithTitle({super.key, required Widget super.child}) : super(margin: const EdgeInsets.all(8.0));

  static create({required Widget child, PaddedText? title, Key? key}) {
    List<Widget> widgets = [];
    if (title != null) {
      widgets.add(title);
      widgets.add(const Divider());
    }
    widgets.add(child);
    return ContainerWithTitle(key: key, child: Column(children: widgets));
  }
}

class LabelListItem extends ListItem {
  LabelListItem({super.key, required String name}) : super(child: Center(child: Text(name)), height: 32);
}

class TileListItem extends ListItem {
  TileListItem({super.key, super.child, required BuildContext context})
      : super(
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(8.0)), color: Theme.of(context).primaryColor),
        );
}

class CharacterListItem extends TileListItem {
  CharacterListItem({super.key, required Character character, required super.context})
      : super(
            child: ListTile(
          subtitle: buildSubtitle(character, context),
          trailing: Text(character.initiative?.toString() ?? "", style: const TextStyle(fontSize: 24)),
          title: Text(character.name),
          dense: true,
          textColor: Theme.of(context).floatingActionButtonTheme.foregroundColor,
        ));

  static Text? buildSubtitle(Character character, BuildContext context) {
    List<String> subtitle = [];
    if (character.subrace != null) {
      subtitle.add(character.subrace!.race.name.localise(context));
    }
    if (character.profession != null) {
      subtitle.add(character.profession!.career.name.localise(context));
    }
    return character.subrace == null && character.profession == null ? null : Text(subtitle.join(", "));
  }
}

class GroupedEntitiesTable extends TileListItem {
  GroupedEntitiesTable({super.key, PaddedText? title, required List<TableSubsection> children, required super.context})
      : super(
            child: children.isEmpty
                ? const SizedBox.shrink()
                : ContainerWithTitle.create(title: title, child: createTable(children)));

  static Widget createTable(List<TableSubsection> children) {
    children.sort((a, b) => a.header!.children[0].text.compareTo(b.header!.children[0].text));
    return Table(columnWidths: {
      for (var i = 0; i < children[0].children[0].children.length; i++)
        i: children[0].children[0].children[i].columnWidth
    }, children: [for (var row in children) row.create()].expand((x) => x).toList());
  }
}

class SingleEntitiesTable extends GroupedEntitiesTable {
  SingleEntitiesTable({super.key, super.title, required List<TableLine> children, required super.context})
      : super(children: children.isEmpty ? [] : [TableSubsection(children: children)]);
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
