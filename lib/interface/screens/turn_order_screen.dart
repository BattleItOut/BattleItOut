import 'package:battle_it_out/interface/screens/character_selection_screen.dart';
import 'package:flutter/material.dart';

import '../components/list_items.dart';

class TurnOrderScreen extends StatefulWidget {
  const TurnOrderScreen({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<TurnOrderScreen> createState() => _TurnOrderScreenState();
}

class _TurnOrderScreenState extends State<TurnOrderScreen> {
  List<CharacterListItem> characters = <CharacterListItem>[
    CharacterListItem(name: 'Player A', colorCode: 600),
    CharacterListItem(name: 'Player B', colorCode: 500),
    CharacterListItem(name: 'Player D', colorCode: 300),
  ];

  void _append() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CharacterSelectionScreen()),
    );
    if (result != null) {
      setState(() {
        characters.add(result);
      });
    }
  }

  void _next() {
    setState(() {
      characters.rotateLeft();
    });
  }

  void _pop(int index) {
    setState(() {
      characters.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    List<ListItem> entries = <ListItem>[];
    for (int i = 0; i < characters.length; i++) {
      if (i == 0) {
        entries.add(LabelListItem(name: 'Current'));
      } if (i == 1) {
        entries.add(LabelListItem(name: 'Next'));
      }
      entries.add(characters[i]);
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
                onDoubleTap: () {
                  if (entries[index] is CharacterListItem) {
                    int actualIndex = index;
                    if (index > 1) {
                      actualIndex--;
                    } if (index > 0) {
                      actualIndex--;
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
