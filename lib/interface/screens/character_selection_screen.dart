import 'package:flutter/material.dart';

import '../components/list_items.dart';

class CharacterSelectionScreen extends StatefulWidget {
  const CharacterSelectionScreen({Key? key}) : super(key: key);

  final String title = "Select a character";

  @override
  State<CharacterSelectionScreen> createState() => _CharacterSelectionScreenState();
}

class _CharacterSelectionScreenState extends State<CharacterSelectionScreen> {
  List<CharacterListItem> characters = <CharacterListItem>[
    CharacterListItem(name: 'Player C', colorCode: 400),
    CharacterListItem(name: 'Player E', colorCode: 200),
    CharacterListItem(name: 'Player F', colorCode: 100),
  ];

  void _select(int index) {
    Navigator.pop(context, characters[index]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(widget.title)),
      ),
      body: Center(
        child: ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: characters.length,
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              child: characters[index],
              onTap: () {
                _select(index);
              }
            );
          }
        )
      )
    );
  }
}
