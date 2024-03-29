import 'package:battle_it_out/interface/components/ancestry_library_item.dart';
import 'package:battle_it_out/interface/components/editable_table.dart';
import 'package:battle_it_out/interface/components/padded_text.dart';
import 'package:battle_it_out/localisation.dart';
import 'package:battle_it_out/persistence/attribute.dart';
import 'package:battle_it_out/persistence/race.dart';
import 'package:battle_it_out/persistence/size.dart';
import 'package:battle_it_out/persistence/subrace.dart';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

class EditRaceScreen extends StatefulWidget {
  final Race? race;
  final List<Subrace>? subraces;
  final List<Attribute>? initialAttributes;
  final List<Size> sizes;
  final List<Attribute> attributes;
  const EditRaceScreen(
      {super.key, this.race, this.subraces, this.initialAttributes, required this.sizes, required this.attributes});

  @override
  State<EditRaceScreen> createState() => _EditRaceScreenState();
}

class _EditRaceScreenState extends State<EditRaceScreen> {
  RacePartial racePartial = RacePartial();
  List<Subrace> ancestries = [];
  List<AttributePartial> initialAttributes = [];

  @override
  void initState() {
    super.initState();
    racePartial = RacePartial.fromRace(widget.race);
    racePartial.source ??= "Custom";

    if (widget.subraces != null) {
      ancestries = widget.subraces!;
    }

    if (widget.initialAttributes != null) {
      initialAttributes = widget.initialAttributes!.map((e) => AttributePartial.from(e)).toList();
    } else {
      initialAttributes = widget.attributes
          .where((e) => e.importance == 0 || e.importance == 1)
          .map((e) => AttributePartial.from(e))
          .toList();
    }
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

  Future<void> save() async {
    Race race = racePartial.toRace();
    race = await RaceFactory().update(race);
    setState(() {
      Navigator.of(context).pop<Tuple3<bool, Race?, List<Attribute>>>(
        Tuple3(true, race, initialAttributes.map((e) => e.toAttribute()).toList()),
      );
    });
  }

  Future<void> delete() async {
    await RaceFactory().delete(widget.race!.id!);
    setState(() {
      Navigator.of(context).pop<Tuple3<bool, Race?, List<Attribute>>>(const Tuple3(true, null, []));
    });
  }

  @override
  Widget build(BuildContext context) {
    List<AttributePartial> primaryAttributes = initialAttributes.where((e) => e.importance == 0).toList();
    List<AttributePartial> secondaryAttributes = initialAttributes.where((e) => e.importance == 1).toList();

    bool compareAttributes = true;
    if (widget.initialAttributes != null && widget.initialAttributes!.length == initialAttributes.length) {
      for (int i = 0; i < initialAttributes.length; i++) {
        compareAttributes = compareAttributes && initialAttributes[i].compareTo(widget.initialAttributes![i]);
      }
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () =>
              Navigator.of(context).pop<Tuple3<bool, Race?, List<Attribute>>>(const Tuple3(false, null, [])),
        ),
        centerTitle: true,
        title: Text("${widget.race != null ? "Edit" : "New"} Race"),
      ),
      body: ListView(shrinkWrap: true, padding: const EdgeInsets.all(10.0), children: [
        Center(child: LocalisedText("NAME", context, style: const TextStyle(fontSize: 24))),
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
        Center(child: LocalisedText("SIZE", context, style: const TextStyle(fontSize: 24))),
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
              DropdownMenuItem<Size>(
                value: size,
                child: Center(child: LocalisedText(size.name, context)),
              )
          ],
        ),
        Center(child: LocalisedText("ATTRIBUTES", context, style: const TextStyle(fontSize: 24))),
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
        Center(child: LocalisedText("ANCESTRIES", context, style: const TextStyle(fontSize: 24))),
        ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(10.0),
          children: ancestries.map<Widget>((ancestry) => AncestryLibraryItemWidget(ancestry: ancestry)).toList(),
        )
      ]),
      floatingActionButton: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
        if (widget.race == null ||
            !racePartial.compareTo(widget.race) ||
            widget.initialAttributes == null ||
            !compareAttributes)
          FloatingActionButton(
            heroTag: "btn2",
            child: const Icon(Icons.save),
            onPressed: () async => await save(),
          ),
        const SizedBox(height: 10),
        if (widget.race != null && widget.initialAttributes != null)
          FloatingActionButton(
            heroTag: "btn1",
            child: const Icon(Icons.delete),
            onPressed: () async => await delete(),
          ),
      ]),
    );
  }
}
