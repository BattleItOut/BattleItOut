import 'package:battle_it_out/interface/components/editable_table.dart';
import 'package:battle_it_out/interface/components/padded_text.dart';
import 'package:battle_it_out/localisation.dart';
import 'package:battle_it_out/persistence/attribute.dart';
import 'package:battle_it_out/persistence/race.dart';
import 'package:battle_it_out/persistence/size.dart';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

class EditRaceScreen extends StatefulWidget {
  final Race? race;
  final List<Size> sizes;
  final List<Attribute> attributes;
  const EditRaceScreen({super.key, this.race, required this.sizes, required this.attributes});

  @override
  State<EditRaceScreen> createState() => _EditRaceScreenState();
}

class _EditRaceScreenState extends State<EditRaceScreen> {
  RacePartial racePartial = RacePartial();

  @override
  void initState() {
    super.initState();
    racePartial = RacePartial.fromRace(widget.race);
    racePartial.initialAttributes ??= widget.attributes
        .where((e) => e.importance == 0 || e.importance == 1)
        .map((e) => AttributePartial.from(e))
        .toList();
    racePartial.source ??= "Custom";
  }

  Tuple2<List<String>, List<List<String>>> getTableData(List<AttributePartial> attributes) {
    List<String> data = [];
    List<String> headers = [];
    for (AttributePartial attribute in attributes) {
      headers.add(AppLocalizations.of(context).localise(attribute.shortName!));
      data.add(attribute.base.toString());
    }
    return Tuple2(headers, [data]);
  }

  void save() {
    Race race = racePartial.toRace();
    setState(() {
      RaceFactory().update(race);
      Navigator.pop(context, race);
    });
  }

  void delete() {
    setState(() {
      RaceFactory().delete(widget.race!.id!);
      Navigator.pop(context, null);
    });
  }

  @override
  Widget build(BuildContext context) {
    List<AttributePartial> primaryAttributes = racePartial.initialAttributes!.where((e) => e.importance == 0).toList();
    List<AttributePartial> secondaryAttributes =
        racePartial.initialAttributes!.where((e) => e.importance == 1).toList();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("${widget.race != null ? "Edit" : "New"} Race"),
      ),
      body: Column(
        children: [
          LocalisedText("NAME", context, style: const TextStyle(fontSize: 24)),
          Container(
            alignment: Alignment.center,
            child: TextFormField(
              textAlign: TextAlign.center,
              initialValue: racePartial.name != null ? AppLocalizations.of(context).localise(racePartial.name!) : "",
              onChanged: (val) {
                setState(() {
                  if (widget.race?.name != null && val == AppLocalizations.of(context).localise(widget.race!.name)) {
                    racePartial.name = widget.race!.name;
                  } else {
                    racePartial.name = val;
                  }
                });
              },
              decoration: const InputDecoration(contentPadding: EdgeInsets.all(8)),
            ),
          ),
          LocalisedText("SIZE", context, style: const TextStyle(fontSize: 24)),
          DropdownButton<Size>(
            value: racePartial.size,
            hint: LocalisedText("SIZE", context),
            isExpanded: true,
            alignment: Alignment.center,
            onChanged: (Size? newValue) {
              setState(() {
                racePartial.size = newValue!;
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
            onChanged: (List<List<String>> editedData) {
              setState(() {
                for (int i = 0; i < editedData[0].length; i++) {
                  primaryAttributes[i].base = int.parse(editedData[0][i]);
                }
              });
            },
          ),
          EditableTable.from(
            data: getTableData(secondaryAttributes),
            onChanged: (List<List<String>> editedData) {
              setState(() {
                for (int i = 0; i < editedData[0].length; i++) {
                  secondaryAttributes[i].base = int.parse(editedData[0][i]);
                }
              });
            },
          ),
        ],
      ),
      floatingActionButton: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
        if (widget.race == null || !racePartial.compareTo(widget.race))
          FloatingActionButton(
            heroTag: "btn2",
            child: const Icon(Icons.save),
            onPressed: () => save(),
          ),
        const SizedBox(height: 10),
        if (widget.race != null)
          FloatingActionButton(
            heroTag: "btn1",
            child: const Icon(Icons.delete),
            onPressed: () => delete(),
          ),
      ]),
    );
  }
}
