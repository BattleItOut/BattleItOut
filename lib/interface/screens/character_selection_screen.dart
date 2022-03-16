import 'package:battle_it_out/entities_localisation.dart';
import 'package:battle_it_out/interface/components/list_items.dart';
import 'package:battle_it_out/interface/components/settings.dart';
import 'package:battle_it_out/interface/screens/character_sheet_screen.dart';
import 'package:battle_it_out/persistence/character.dart';
import 'package:battle_it_out/state_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CharacterSelectionScreen extends StatefulWidget {

  const CharacterSelectionScreen({Key? key}) : super(key: key);

  @override
  State<CharacterSelectionScreen> createState() => _CharacterSelectionScreenState();
}

class _CharacterSelectionScreenState extends State<CharacterSelectionScreen> {
  late List<Character> savedCharacters;

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
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("INITIATIVE".localise(context)),
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
              child: Text("PROCEED".localise(context)),
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
      builder: (context) => CharacterSheetScreen(character: savedCharacters[index]),
    ));
  }

  @override
  Widget build(BuildContext context) {
    savedCharacters = StateContainer.of(context).savedCharacters;
    var characters = _generateCharacters();
    return Scaffold(
      appBar: applicationBar("CHARACTER_SELECTION_SCREEN_TITLE".localise(context)),
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
      endDrawer: settingsDrawer(context)
    );
  }
}
