import 'package:battle_it_out/app_cache.dart';
import 'package:battle_it_out/interface/screens/character_sheet_screen.dart';
import 'package:battle_it_out/persistence/character.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
        character: widget.characters[index],
        context: context
      )
    );
  }

  void _select(int index) {
    var character = Character.from(widget.characters[index]);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Initiative:"),
          content: TextField(
            onChanged: (value) {
              character.initiative = int.parse(value);
            },
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              child: const Text("Proceed"),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pop(context, character);
              },
            ),
          ],
        );
      },
    );
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
