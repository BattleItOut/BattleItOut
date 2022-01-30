import 'package:battle_it_out/app_cache.dart';
import 'package:battle_it_out/interface/screens/character_sheet_screen.dart';
import 'package:battle_it_out/persistence/character.dart';
import 'package:flutter/material.dart';

import '../components/list_items.dart';

class CharacterSelectionScreen extends StatefulWidget {
  CharacterSelectionScreen({Key? key}) : super(key: key);

  final String title = "Select a character";
  final List<Character> characters = AppCache().characters;

  @override
  State<CharacterSelectionScreen> createState() => _CharacterSelectionScreenState();
}

class _CharacterSelectionScreenState extends State<CharacterSelectionScreen> {
  List<CharacterListItem> _generateCharacters() {
    return List<CharacterListItem>.generate(
        widget.characters.length,
            (index) => CharacterListItem(
            name: widget.characters[index].name,
            colorCode: 500
        )
    );
  }

  void _select(int index) {
    Navigator.pop(context, widget.characters[index]);
  }

  void _info(int index) {
    Navigator.push(context, MaterialPageRoute(
      builder: (context) => CharacterSheetScreen(character: widget.characters[index]),
    ));
  }

  @override
  Widget build(BuildContext context) {
    var characters = _generateCharacters();
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
              },
              onLongPress: () {
                _info(index);
              }
            );
          }
        )
      )
    );
  }
}
