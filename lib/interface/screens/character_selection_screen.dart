import 'package:battle_it_out/app_cache.dart';
import 'package:battle_it_out/interface/components/alert.dart';
import 'package:battle_it_out/interface/screens/character_sheet_screen.dart';
import 'package:battle_it_out/persistence/character.dart';
import 'package:battle_it_out/persistence/entities/attribute.dart';
import 'package:battle_it_out/persistence/entities/profession.dart';
import 'package:battle_it_out/persistence/entities/race.dart';
import 'package:battle_it_out/persistence/entities/size.dart';
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
        character: widget.characters[index],
        context: context
      )
    );
  }

  void _select(int index) {
    var character = Character.from(widget.characters[index]);
    showAlert(
      "Initiative:",
      (value) { character.initiative = int.parse(value); },
      int,
      () {
        Navigator.of(context).pop();
        Navigator.pop(context, character);
      },
      context
    );
  }

  void _info(int index) {
    Navigator.push(context, MaterialPageRoute(
      builder: (context) => CharacterSheetScreen(character: widget.characters[index]),
    ));
  }

  void _newCharacter() {
    String? name;
    showAlert(
      "Name:",
      (value) => name = value,
      String,
      () {
        Navigator.of(context).pop();
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => CharacterSheetScreen(character:
            Character(
              name: name!,
              race: Race(
                name: "",
                size: Size(name: "")
              ),
              profession: Profession(name: ""),
              attributes: {0: Attribute(id: 0, name: "WW", rollable: 1, importance: 1)}
            )
          ),
        ));
      },
      context
    );
    // AppCache().characters.add(value)
  }

  void _onNavigationTapped(int index) {
    switch (index) {
      case 0:
        _newCharacter();
        break;
    }
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
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.add), label: "Add a character"),
          BottomNavigationBarItem(icon: Icon(Icons.block), label: "Do nothing"),
        ],
        onTap: _onNavigationTapped,
      ),
    );
  }
}
