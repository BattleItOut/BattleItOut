import 'package:battle_it_out/interface/components/editable_table.dart';
import 'package:battle_it_out/interface/components/padded_text.dart';
import 'package:battle_it_out/localisation.dart';
import 'package:battle_it_out/persistence/attribute.dart';
import 'package:battle_it_out/persistence/race.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class EditRaceScreen extends StatefulWidget {
  final Race race;
  const EditRaceScreen({super.key, required this.race});

  @override
  State<EditRaceScreen> createState() => _EditRaceScreenState();
}

class _EditRaceScreenState extends State<EditRaceScreen> {
  List<Attribute> attributes = [];
  Race? race;
  bool isNameReady = false;
  bool isCharReady = false;
  bool isChar2Ready = false;

  @override
  void initState() {
    super.initState();
    race = Race.copy(widget.race);
    attributes = race!.getInitialAttributes();
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
        const SizedBox(height: 10),
        FloatingActionButton(child: const Icon(Icons.restart_alt), onPressed: () {})
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
              onChanged: (value) {
                if (value == AppLocalizations.of(context).localise(widget.race.name)) {
                  race!.name = widget.race.name;
                } else {
                  race!.name = value;
                }
              },
              decoration: const InputDecoration(contentPadding: EdgeInsets.all(8)),
            ),
          ),
          LocalisedText("ATTRIBUTES", context, style: const TextStyle(fontSize: 24)),
          EditableTable.from(
            data: getTableData(attributes.where((e) => e.importance == 0).toList()),
            onChanged: (List data, List editedData) {
              isCharReady = !const DeepCollectionEquality().equals(editedData, data);
            },
          ),
          EditableTable.from(
            data: getTableData(attributes.where((e) => e.importance >= 1).toList()),
            onChanged: (List data, List editedData) {
              isChar2Ready = !const DeepCollectionEquality().equals(editedData, data);
            },
          ),
        ],
      ),
      floatingActionButton: Column(mainAxisAlignment: MainAxisAlignment.end, children: floatingButtons),
    );
  }
}
