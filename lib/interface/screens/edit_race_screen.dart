import 'package:battle_it_out/interface/components/ancestry_library_item.dart';
import 'package:battle_it_out/interface/components/editable_table.dart';
import 'package:battle_it_out/interface/components/list_items.dart';
import 'package:battle_it_out/interface/components/padded_text.dart';
import 'package:battle_it_out/interface/screens/edit_ancestry_screen.dart';
import 'package:battle_it_out/localisation.dart';
import 'package:battle_it_out/persistence/ancestry.dart';
import 'package:battle_it_out/persistence/attribute.dart';
import 'package:battle_it_out/persistence/race.dart';
import 'package:battle_it_out/persistence/size.dart';
import 'package:battle_it_out/providers/attribute_provider.dart';
import 'package:battle_it_out/providers/race_provider.dart';
import 'package:battle_it_out/providers/size_provider.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class EditRaceScreen extends StatefulWidget {
  final Race? race;
  const EditRaceScreen({super.key, this.race});

  @override
  State<EditRaceScreen> createState() => _EditRaceScreenState();
}

class _EditRaceScreenState extends State<EditRaceScreen> {
  RacePartial racePartial = RacePartial();
  List<Ancestry> ancestries = [];
  List<AttributePartial> attributes = [];

  @override
  void initState() {
    super.initState();
    racePartial = RacePartial.from(widget.race);
    racePartial.source ??= "Custom";
    ancestries = widget.race!.ancestries;
    attributes = (widget.race?.attributes ?? GetIt.instance.get<AttributeRepository>().items)
        .where((e) => e.importance == 0 || e.importance == 1)
        .map((e) => AttributePartial.from(e))
        .toList();
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
    await GetIt.instance.get<RaceRepository>().update(racePartial.toRace());
    setState(() {
      Navigator.of(context).pop();
    });
  }

  Future<void> delete() async {
    await GetIt.instance.get<RaceRepository>().delete(widget.race!);
    setState(() {
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    List<AttributePartial> primaryAttributes = attributes.where((e) => e.importance == 0).toList();
    List<AttributePartial> secondaryAttributes = attributes.where((e) => e.importance == 1).toList();

    bool compareAttributes = true;
    if (widget.race?.attributes != null && widget.race?.attributes.length == attributes.length) {
      for (int i = 0; i < attributes.length; i++) {
        if (attributes[i].base != widget.race?.attributes[i].base) {
          compareAttributes = false;
          break;
        }
      }
    }

    SizeRepository repository = Provider.of<SizeRepository>(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
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
            for (Size size in repository.items)
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
          children: [
            ...ancestries.map<Widget>(
              (ancestry) => AncestryLibraryItemWidget(
                ancestry: ancestry,
                onLongPress: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => EditAncestryScreen(ancestry: ancestry)),
                ),
              ),
            ),
            ListItem(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                color: Theme.of(context).primaryColor,
              ),
              child: ListTile(
                title: IconButton(onPressed: () {}, icon: const Icon(Icons.add)),
                textColor: Theme.of(context).floatingActionButtonTheme.foregroundColor,
                dense: true,
              ),
            )
          ],
        )
      ]),
      floatingActionButton: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
        if (widget.race == null ||
            !racePartial.compareTo(widget.race) ||
            widget.race?.attributes == null ||
            !compareAttributes)
          FloatingActionButton(
            heroTag: "btn2",
            child: const Icon(Icons.save),
            onPressed: () async => await save(),
          ),
        const SizedBox(height: 10),
        if (widget.race != null && widget.race?.attributes != null)
          FloatingActionButton(
            heroTag: "btn1",
            child: const Icon(Icons.delete),
            onPressed: () async => await delete(),
          ),
      ]),
    );
  }
}
