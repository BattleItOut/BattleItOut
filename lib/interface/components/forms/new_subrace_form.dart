import 'package:battle_it_out/entities_localisation.dart';
import 'package:battle_it_out/persistence/ancestry.dart';
import 'package:battle_it_out/persistence/race.dart';
import 'package:battle_it_out/persistence/size.dart';
import 'package:flutter/material.dart';

class NewAncestryForm extends StatefulWidget {
  final Race race;

  const NewAncestryForm(this.race, {super.key});

  @override
  State<NewAncestryForm> createState() => _NewAncestryFormState();
}

class _NewAncestryFormState extends State<NewAncestryForm> {
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
            AncestryFactory()
                .update(Ancestry(name: nameTextController.text, race: widget.race))
                .then((Ancestry ancestry) => Navigator.of(context).pop(ancestry));
          },
        ),
      ],
    );
  }
}
