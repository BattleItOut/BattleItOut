import 'package:battle_it_out/entities_localisation.dart';
import 'package:battle_it_out/persistence/race.dart';
import 'package:battle_it_out/persistence/size.dart';
import 'package:flutter/material.dart';

class NewRaceForm extends StatefulWidget {
  final List<Size> sizes;

  const NewRaceForm(this.sizes, {super.key});

  @override
  State<NewRaceForm> createState() => _NewRaceFormState();
}

class _NewRaceFormState extends State<NewRaceForm> {
  final nameTextController = TextEditingController();
  String? name;
  Size? size;

  @override
  void initState() {
    super.initState();
    size = widget.sizes[3];
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Nowe rasa", textAlign: TextAlign.center),
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
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButtonFormField<Size>(
                value: size,
                decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Size'),
                onChanged: (Size? value) => setState(() => size = value!),
                items: widget.sizes.map<DropdownMenuItem<Size>>((Size value) {
                  return DropdownMenuItem<Size>(value: value, child: Text(value.name.localise(context)));
                }).toList(),
              ),
            ),
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
            RaceFactory()
                .insert(Race(name: nameTextController.text, size: size!))
                .then((Race race) => Navigator.of(context).pop(race));
          },
        ),
      ],
    );
  }
}
