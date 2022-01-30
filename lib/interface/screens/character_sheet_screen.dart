import 'package:battle_it_out/persistence/character.dart';
import 'package:flutter/material.dart';

class CharacterSheetScreen extends StatefulWidget {
  const CharacterSheetScreen({Key? key, required this.character}) : super(key: key);

  final Character character;

  @override
  State<CharacterSheetScreen> createState() => _CharacterSheetScreenState();
}

class _CharacterSheetScreenState extends State<CharacterSheetScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(widget.character.name)),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Race: ${widget.character.race.name}"),
          Text("Subrace: ${widget.character.subrace.toString()}"),
          Text("Size: ${widget.character.race.size}"),
          Text("Profession: ${widget.character.profession.name}"),
        ]
      )
    );
  }
}
