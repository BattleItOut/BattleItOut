import 'package:battle_it_out/interface/components/editable_table.dart';
import 'package:battle_it_out/interface/components/padded_text.dart';
import 'package:battle_it_out/localisation.dart';
import 'package:battle_it_out/persistence/attribute.dart';
import 'package:battle_it_out/persistence/race.dart';
import 'package:battle_it_out/persistence/size.dart';
import 'package:flutter/material.dart';

class EditRaceScreen extends StatefulWidget {
  final Race race;
  final List<Size> sizes;
  const EditRaceScreen({super.key, required this.race, required this.sizes});

  @override
  State<EditRaceScreen> createState() => _EditRaceScreenState();
}

class _EditRaceScreenState extends State<EditRaceScreen> {
  List<Attribute> primaryAttributes = [];
  List<Attribute> secondaryAttributes = [];
  Race? race;

  @override
  void initState() {
    super.initState();
    race = Race.copy(widget.race);
    List<Attribute> attributes = race!.getInitialAttributes();
    primaryAttributes = attributes.where((e) => e.importance == 0).toList();
    secondaryAttributes = attributes.where((e) => e.importance >= 1).toList();
  }

  getTableData(List<Attribute> attributes) {
    List data = [];
    List headers = [];
    for (Attribute attribute in attributes) {
      headers.add(AppLocalizations.of(context).localise(attribute.shortName));
      data.add(attribute.base.toString());
    }
    return [
      headers,
      [data]
    ];
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> floatingButtons = [FloatingActionButton(child: const Icon(Icons.delete), onPressed: () {})];
    if (widget.race != race) {
      floatingButtons.addAll([
        const SizedBox(height: 10),
        FloatingActionButton(child: const Icon(Icons.save), onPressed: () {}),
      ]);
    }
    floatingButtons = floatingButtons.reversed.toList();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Edit Race"),
      ),
      body: Column(
        children: [
          LocalisedText("NAME", context, style: const TextStyle(fontSize: 24)),
          Container(
            alignment: Alignment.center,
            child: TextFormField(
              textAlign: TextAlign.center,
              initialValue: AppLocalizations.of(context).localise(race!.name),
              onChanged: (val) {
                setState(() {
                  race!.name = val == AppLocalizations.of(context).localise(widget.race.name) ? widget.race.name : val;
                });
              },
              decoration: const InputDecoration(contentPadding: EdgeInsets.all(8)),
            ),
          ),
          LocalisedText("SIZE", context, style: const TextStyle(fontSize: 24)),
          DropdownButton<Size>(
            value: race!.size,
            hint: LocalisedText("SIZE", context),
            isExpanded: true,
            alignment: Alignment.center,
            onChanged: (Size? newValue) {
              setState(() {
                race!.size = newValue!;
              });
            },
            items: [
              for (Size size in widget.sizes)
                DropdownMenuItem<Size>(value: size, child: Center(child: LocalisedText(size.name, context)))
            ],
          ),
          LocalisedText("ATTRIBUTES", context, style: const TextStyle(fontSize: 24)),
          EditableTable.from(
            data: getTableData(primaryAttributes),
            onChanged: (List editedData) {
              setState(() {
                for (int i = 0; i < editedData[0].length; i++) {
                  primaryAttributes[i].base = int.parse(editedData[0][i]);
                }
              });
            },
          ),
          EditableTable.from(
            data: getTableData(secondaryAttributes),
            onChanged: (List editedData) {
              setState(() {
                for (int i = 0; i < editedData[0].length; i++) {
                  secondaryAttributes[i].base = int.parse(editedData[0][i]);
                }
              });
            },
          ),
        ],
      ),
      floatingActionButton: Column(mainAxisAlignment: MainAxisAlignment.end, children: floatingButtons),
    );
  }
}
