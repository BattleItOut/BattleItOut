import 'package:battle_it_out/entities_localisation.dart';
import 'package:battle_it_out/persistence/race.dart';
import 'package:battle_it_out/persistence/size.dart';
import 'package:battle_it_out/persistence/subrace.dart';
import 'package:flutter/material.dart';

class NewSubraceForm extends StatefulWidget {
  final Race race;

  const NewSubraceForm(this.race, {super.key});

  @override
  State<NewSubraceForm> createState() => _NewSubraceFormState();
}

class _NewSubraceFormState extends State<NewSubraceForm> {
  late List<Size> sizes;
  final nameTextController = TextEditingController();

  String? name;

  @override
  void dispose() {
    nameTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "Nowe pochodzenie (${widget.race.name.localise(context)})",
        textAlign: TextAlign.center,
      ),
      content: SizedBox(
        width: 400,
        child: ListView(
          shrinkWrap: true,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: nameTextController,
                decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Name'),
              ),
            )
          ],
        ),
      ),
      actions: [
        TextButton(
          child: Text("CANCEL".localise(context)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
          child: Text("PROCEED".localise(context)),
          onPressed: () {
            SubraceFactory()
                .update(Subrace(name: nameTextController.text, race: widget.race))
                .then((Subrace subrace) => Navigator.of(context).pop(subrace));
          },
        ),
      ],
    );
  }
}
