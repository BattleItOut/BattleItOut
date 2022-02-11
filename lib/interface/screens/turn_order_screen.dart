import 'package:battle_it_out/interface/screens/character_selection_screen.dart';
import 'package:battle_it_out/persistence/character.dart';
import 'package:flutter/material.dart';

import '../components/list_items.dart';

class TurnOrderScreen extends StatefulWidget {
  const TurnOrderScreen({Key? key}) : super(key: key);

  final String title = "Turn order";

  @override
  State<TurnOrderScreen> createState() => _TurnOrderScreenState();
}

class _TurnOrderScreenState extends State<TurnOrderScreen> {
  var characters = <Character>[];
  var currentRound = 0;

  bool _isNextCharacterInNextRound(int index) {
    return characters.length != index + 1 &&
        characters[index].initiative! < characters[index + 1].initiative!;
  }

  void _append() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CharacterSelectionScreen()),
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

  void _next() {
    setState(() {
      if (_isNextCharacterInNextRound(0)) {
        currentRound++;
      }
      characters.rotateLeft();
    });
  }

  void _pop(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Remove a character"),
          content: const Text("Are you sure you want to remove this character from the fight?"),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Proceed"),
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
        entries.add(LabelListItem(name: 'Current'));
      }
      else if (i != 0 && _isNextCharacterInNextRound(i - 1)) {
        entries.add(LabelListItem(name: 'Round ${currentRound + 1}'));
      }
      else if (i == 1) {
        entries.add(LabelListItem(name: 'Next'));
      }
      entries.add(CharacterListItem(character: characters[i], context: context));
    }
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(widget.title)),
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
                    _next();
                  }
                },
                onLongPress: () {
                  if (entries[index] is CharacterListItem) {
                    var labelIndexes = <int>[];
                    int actualIndex = index;
                    for (int i = 0; i < entries.length; i++) {
                      if (entries[i] is LabelListItem) labelIndexes.add(i);
                    }
                    for (int labelIndex in labelIndexes) {
                      if (index > labelIndex) actualIndex--;
                    }
                    _pop(actualIndex);
                  }
                }
            );
          }
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _append,
        tooltip: 'Add',
        child: const Icon(Icons.add),
      ),
    );
  }
}
