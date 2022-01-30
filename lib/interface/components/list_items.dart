import 'package:flutter/material.dart';

class ListItem extends Container {
  ListItem({
    Key? key,
    required String name,
    double? height,
    BoxDecoration? decoration
  }) : super(
      key: key,
      margin: const EdgeInsets.all(4.0),
      height: height,
      decoration: decoration,
      child: Center(child: Text(name))
  );
}

class LabelListItem extends ListItem {
  LabelListItem({Key? key, required String name}) : super(
      key: key,
      name: name,
      height: 32
  );
}

class CharacterListItem extends ListItem {
  CharacterListItem({Key? key, required String name, required BuildContext context}) : super(
    key: key,
    name: name,
    height: 48,
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