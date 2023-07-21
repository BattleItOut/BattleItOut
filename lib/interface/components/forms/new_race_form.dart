import 'package:battle_it_out/entities_localisation.dart';
import 'package:battle_it_out/persistence/race.dart';
import 'package:battle_it_out/persistence/size.dart';
import 'package:flutter/material.dart';

class NewRaceForm extends StatefulWidget {
  const NewRaceForm({super.key});

  @override
  State<NewRaceForm> createState() => _NewRaceFormState();
}

class _NewRaceFormState extends State<NewRaceForm> {
  late List<Size> sizes;
  final nameTextController = TextEditingController();

  String? name;
  Size? size;

  Future<void> getAsyncData(BuildContext context) async {
    sizes = await SizeFactory().getAll();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getAsyncData(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
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
                      value: size ?? sizes[3],
                      decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Size'),
                      onChanged: (Size? value) => setState(() => size = value!),
                      items: sizes.map<DropdownMenuItem<Size>>((Size value) {
                        return DropdownMenuItem<Size>(value: value, child: Text(value.name.localise(context)));
                      }).toList(),
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
                  RaceFactory().create({"NAME": nameTextController.text, "SIZE_ID": size!.id});
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        }
        return const CircularProgressIndicator();
      },
    );
  }
}
