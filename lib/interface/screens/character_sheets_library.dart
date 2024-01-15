import 'package:battle_it_out/interface/components/list_items.dart';
import 'package:battle_it_out/interface/screens/character_sheet_screen.dart';
import 'package:battle_it_out/interface/state_container.dart';
import 'package:battle_it_out/persistence/character.dart';
import 'package:flutter/material.dart';

class CharacterSheetsLibrary extends StatefulWidget {
  const CharacterSheetsLibrary({Key? key}) : super(key: key);

  @override
  State<CharacterSheetsLibrary> createState() => _CharacterSheetsLibraryState();
}

class _CharacterSheetsLibraryState extends State<CharacterSheetsLibrary> {
  List<Character> savedCharacters = [];

  List<CharacterListItem> _generateCharacters() {
    return List<CharacterListItem>.generate(
      savedCharacters.length,
      (index) => CharacterListItem(character: savedCharacters[index], context: context),
    );
  }

  void _info(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CharacterSheetScreen(character: savedCharacters[index])),
    );
  }

  @override
  Widget build(BuildContext context) {
    savedCharacters = StateContainer.of(context).savedCharacters;
    var characters = _generateCharacters();
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: characters.length,
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              child: characters[index],
              onTap: () {
                _info(index);
              },
            );
          },
        ),
      ),
    );
  }
}
