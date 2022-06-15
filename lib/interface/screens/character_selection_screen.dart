import 'package:battle_it_out/entities_localisation.dart';
import 'package:battle_it_out/interface/components/alert.dart';
import 'package:battle_it_out/interface/components/list_items.dart';
import 'package:battle_it_out/interface/screens/character_sheet_screen.dart';
import 'package:battle_it_out/persistence/character.dart';
import 'package:battle_it_out/interface/state_container.dart';
import 'package:battle_it_out/persistence/entities/attribute.dart';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

class CharacterSelectionScreen extends StatefulWidget {

  const CharacterSelectionScreen({Key? key}) : super(key: key);

  @override
  State<CharacterSelectionScreen> createState() => _CharacterSelectionScreenState();
}

class _CharacterSelectionScreenState extends State<CharacterSelectionScreen> {
  List<Character> savedCharacters = [];

  List<CharacterListItem> _generateCharacters() {
    return List<CharacterListItem>.generate(
      savedCharacters.length,
      (index) => CharacterListItem(
        character: savedCharacters[index],
        context: context
      )
    );
  }

  void _select(int index) {
    var character = Character.from(savedCharacters[index]);
    showAlert(
      "INITIATIVE".localise(context),
      [
        Tuple2((value) { character.initiative = int.parse(value); }, int)
      ],
      () {
        Navigator.of(context).pop();
        Navigator.pop(context, character);
      },
      context
    );
  }

  void _info(int index) {
    Navigator.push(context, MaterialPageRoute(
      builder: (context) => CharacterSheetScreen(character: savedCharacters[index]),
    ));
  }

  void _newCharacter() {
    String? name;
    showAlert(
      "NAME".localise(context),
      [
        Tuple2((value) => name = value, String)
      ],
      () {
        var newCharacter = Character(
          name: name!,
          attributes: { 0: Attribute(id: 0, name: "WW", shortName: "WW", description: "WW", rollable: 1, importance: 1) }
        );
        StateContainer.of(context).addCharacter(newCharacter);
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
    savedCharacters = StateContainer.of(context).savedCharacters;
    var characters = _generateCharacters();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("CHARACTER_SELECTION_SCREEN_TITLE".localise(context)),
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
