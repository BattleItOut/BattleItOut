import 'package:battle_it_out/entities_localisation.dart';
import 'package:battle_it_out/interface/components/forms/new_subrace_form.dart';
import 'package:battle_it_out/interface/components/list_items.dart';
import 'package:battle_it_out/persistence/race.dart';
import 'package:battle_it_out/persistence/skill/skill.dart';
import 'package:battle_it_out/persistence/skill/skill_group.dart';
import 'package:battle_it_out/persistence/subrace.dart';
import 'package:flutter/material.dart';

class RaceLibraryItemWidget extends StatefulWidget {
  final Race race;
  final List<Subrace> subraces;

  const RaceLibraryItemWidget(this.race, this.subraces, {super.key});

  @override
  State<RaceLibraryItemWidget> createState() => _RaceLibraryItemWidgetState();
}

class _RaceLibraryItemWidgetState extends State<RaceLibraryItemWidget> {
  List<Subrace> subraces = [];

  @override
  void initState() {
    super.initState();
    subraces = widget.subraces;
  }

  Text buildLinkedSKills(BuildContext context, Subrace subrace) {
    List<String> skillNames = [for (Skill skill in subrace.linkedSkills) skill.name.localise(context)];
    skillNames.addAll([for (SkillGroup skillGroup in subrace.linkedGroupSkills) skillGroup.name.localise(context)]);
    skillNames.sort((a, b) => a.compareTo(b));

    if (skillNames.isEmpty) {
      return const Text("");
    }
    return Text.rich(
      TextSpan(children: <TextSpan>[
        TextSpan(text: "${"SKILLS".localise(context)}: ", style: const TextStyle(fontWeight: FontWeight.bold)),
        TextSpan(text: skillNames.join(", "))
      ]),
      textAlign: TextAlign.center,
    );
  }

  Text buildLinkedTalents(BuildContext context, Subrace subrace) {
    List<String> talentNames = [for (var talent in subrace.linkedTalents) talent.name.localise(context)];
    talentNames.addAll([for (var talentGroup in subrace.linkedGroupTalents) talentGroup.name.localise(context)]);
    talentNames.sort((a, b) => a.compareTo(b));

    List<TextSpan> children = [
      TextSpan(text: "${"TALENTS".localise(context)}: ", style: const TextStyle(fontWeight: FontWeight.bold)),
      TextSpan(text: talentNames.join(", "))
    ];
    if (subrace.randomTalents > 0) {
      children.add(const TextSpan(text: ", "));
      children.add(TextSpan(text: "${subrace.randomTalents.toString()} ${"RANDOM_TALENTS".localise(context)}"));
    }

    if (talentNames.isEmpty) {
      return const Text("");
    } else {
      return Text.rich(TextSpan(children: children), textAlign: TextAlign.center);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListItem(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(8.0)),
        color: Theme.of(context).primaryColor,
      ),
      child: ListTile(
        title: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(7),
              child: Text(
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                widget.race.name.localise(context),
              ),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              for (var attribute in widget.race.initialAttributes.where((e) => e.importance == 0))
                Padding(
                  padding: const EdgeInsets.all(7),
                  child: Column(
                    children: [
                      Text(attribute.shortName.localise(context)),
                      Text(attribute.base.toString()),
                    ],
                  ),
                ),
            ]),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var attribute in widget.race.initialAttributes.where((e) => e.importance == 1))
                  Padding(
                    padding: const EdgeInsets.all(7),
                    child: Column(
                      children: [
                        Text(attribute.shortName.localise(context)),
                        Text(attribute.base.toString()),
                      ],
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(7),
                  child: Column(children: [
                    Text("SIZE".localise(context)),
                    Text(widget.race.size.name.localise(context)),
                  ]),
                )
              ],
            ),
          ],
        ),
        subtitle: Column(children: [
          for (Subrace subrace in subraces)
            Padding(
              padding: const EdgeInsets.all(7),
              child: Column(children: [
                subraces.length != 1
                    ? Text(
                        subrace.name.localise(context),
                        style: const TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
                      )
                    : const SizedBox.shrink(),
                subrace.linkedSkills.isNotEmpty || subrace.linkedGroupSkills.isNotEmpty
                    ? buildLinkedSKills(context, subrace)
                    : const SizedBox.shrink(),
                subrace.linkedTalents.isNotEmpty || subrace.linkedGroupTalents.isNotEmpty
                    ? buildLinkedTalents(context, subrace)
                    : const SizedBox.shrink(),
              ]),
            ),
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () => showDialog<Subrace>(
              context: context,
              builder: (BuildContext context) => NewSubraceForm(widget.race),
            ).then((Subrace? subrace) {
              if (subrace != null) {
                setState(() => subraces.add(subrace));
              }
            }),
          ),
        ]),
        onLongPress: () => {},
        textColor: Theme.of(context).floatingActionButtonTheme.foregroundColor,
        dense: true,
      ),
    );
  }
}
