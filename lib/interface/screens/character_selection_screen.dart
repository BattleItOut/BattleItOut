import 'package:battle_it_out/app_cache.dart';
import 'package:battle_it_out/entities_localisation.dart';
import 'package:battle_it_out/interface/components/alert.dart';
import 'package:battle_it_out/interface/screens/character_sheet_screen.dart';
import 'package:battle_it_out/persistence/character.dart';
import 'package:battle_it_out/persistence/entities/profession.dart';
import 'package:battle_it_out/persistence/entities/race.dart';
import 'package:battle_it_out/persistence/entities/size.dart';
import 'package:flutter/material.dart';

import '../components/list_items.dart';

class CharacterSelectionScreen extends StatefulWidget {
  CharacterSelectionScreen({Key? key}) : super(key: key);

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
      "INITIATIVE".localise(context),
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
      "NAME".localise(context),
      (value) => name = value,
      String,
      () {
        var newCharacter = Character(
          name: name!,
          race: Race(
            name: "",
            size: Size(name: "")
          ),
          profession: Profession(name: ""),
          attributes: {}
        );
        widget.characters.add(newCharacter);
        Navigator.of(context).pop();
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => CharacterSheetScreen(character: newCharacter),
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
        title: Center(child: Text("CHARACTER_SELECTION_SCREEN_TITLE".localise(context))),
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
        items: [
          BottomNavigationBarItem(icon: const Icon(Icons.add), label: "ADD_CHARACTER".localise(context)),
          BottomNavigationBarItem(icon: const Icon(Icons.block), label: "DO_NOTHING".localise(context)),
        ],
        onTap: _onNavigationTapped,
      ),
    );
  }
}
