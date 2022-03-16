import 'package:battle_it_out/entities_localisation.dart';
import 'package:battle_it_out/interface/screens/character_selection_screen.dart';
import 'package:battle_it_out/persistence/character.dart';
import 'package:flutter/material.dart';

import '../components/list_items.dart';
import 'character_sheet_screen.dart';

class TurnOrderScreen extends StatefulWidget {
  const TurnOrderScreen({Key? key}) : super(key: key);

  @override
  State<TurnOrderScreen> createState() => _TurnOrderScreenState();
}

class _TurnOrderScreenState extends State<TurnOrderScreen> {
  var characters = <Character>[];
  var currentRound = 0;

  bool _isPreviousCharacterInPreviousRound() {
    return characters[0].initiative! > characters[characters.length - 1].initiative!;
  }

  bool _isNextCharacterInNextRound(int index) {
    return characters.length != index + 1 &&
        characters[index].initiative! < characters[index + 1].initiative!;
  }

  int _getActualIndex(List entries, int index) {
    var labelIndexes = <int>[];
    int actualIndex = index;
    for (int i = 0; i < entries.length; i++) {
      if (entries[i] is LabelListItem) labelIndexes.add(i);
    }
    for (int labelIndex in labelIndexes) {
      if (index > labelIndex) actualIndex--;
    }
    return actualIndex;
  }

  void _append() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CharacterSelectionScreen()),
    );
    if (result != null) {
      var index = 0;
      while (index < characters.length && characters[index].initiative! > result.initiative!) {
        index++;
      }
      setState(() {
        characters.insert(index, result);
      });
    }
  }

  void _previous() {
    setState(() {
      if (_isPreviousCharacterInPreviousRound()) {
        if (currentRound == 0) return;
        currentRound--;
      }
      characters.rotateRight();
    });
  }

  void _next() {
    setState(() {
      if (_isNextCharacterInNextRound(0)) {
        currentRound++;
      }
      characters.rotateLeft();
    });
  }

  void _info(int index) {
    Navigator.push(context, MaterialPageRoute(
      builder: (context) => CharacterSheetScreen(character: characters[index]),
    ));
  }

  void _onNavigationTapped(int index) {
    switch (index) {
      case 0:
        _previous();
        break;
      case 1:
        _append();
        break;
      case 2:
        _next();
        break;
    }
  }

  void _pop(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("REMOVE_CHARACTER_PROMPT".localise(context)),
          content: Text("REMOVE_CHARACTER_PROMPT_DESC".localise(context)),
          actions: [
            TextButton(
              child: Text("CANCEL".localise(context)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("PROCEED".localise(context)),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  characters.removeAt(index);
                });
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<ListItem> entries = <ListItem>[];
    for (int i = 0; i < characters.length; i++) {
      if (i == 0) {
        entries.add(LabelListItem(name: '${"CURRENT".localise(context)} (${"ROUND".localise(context)} $currentRound)'));
      }
      else if (i != 0 && _isNextCharacterInNextRound(i - 1)) {
        entries.add(LabelListItem(name: '${"ROUND".localise(context)} ${currentRound + 1}'));
      }
      else if (i == 1) {
        entries.add(LabelListItem(name: "NEXT".localise(context)));
      }
      entries.add(CharacterListItem(character: characters[i], context: context));
    }
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("TURN_ORDER_SCREEN_TITLE".localise(context)),
      ),
      body: Center(
        child: ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: entries.length,
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
                child: entries[index],
                onTap: () {
                  if (entries[index] is CharacterListItem) {
                    _pop(_getActualIndex(entries, index));
                  }
                },
                onLongPress: () {
                  if (entries[index] is CharacterListItem) {
                    _info(_getActualIndex(entries, index));
                  }
                }
            );
          }
        )
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: const Icon(Icons.navigate_before), label: "PREVIOUS".localise(context)),
          BottomNavigationBarItem(icon: const Icon(Icons.add), label: "ADD".localise(context)),
          BottomNavigationBarItem(icon: const Icon(Icons.navigate_next), label: "NEXT".localise(context))
        ],
        onTap: _onNavigationTapped,
      ),
    );
  }
}
