import 'package:battle_it_out/app_cache.dart';
import 'package:flutter/material.dart';

import '../components/list_items.dart';

class CharacterSelectionScreen extends StatefulWidget {
  const CharacterSelectionScreen({Key? key}) : super(key: key);

  final String title = "Select a character";

  @override
  State<CharacterSelectionScreen> createState() => _CharacterSelectionScreenState();
}

class _CharacterSelectionScreenState extends State<CharacterSelectionScreen> {
  var characters = List<CharacterListItem>.generate(
      AppCache().characters.length,
      (index) => CharacterListItem(
        name: AppCache().characters[index].name,
        colorCode: 500
      )
  );

  void _select(int index) {
    Navigator.pop(context, characters[index]);
  }

  @override
  Widget build(BuildContext context) {
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
              }
            );
          }
        )
      )
    );
  }
}
