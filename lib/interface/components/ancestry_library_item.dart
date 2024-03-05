import 'package:battle_it_out/entities_localisation.dart';
import 'package:battle_it_out/interface/components/list_items.dart';
import 'package:battle_it_out/persistence/skill/skill.dart';
import 'package:battle_it_out/persistence/skill/skill_group.dart';
import 'package:battle_it_out/persistence/subrace.dart';
import 'package:flutter/material.dart';

class AncestryLibraryItemWidget extends StatefulWidget {
  final Subrace ancestry;
  final void Function()? onTap;
  final void Function()? onLongPress;

  const AncestryLibraryItemWidget({super.key, required this.ancestry, this.onTap, this.onLongPress});

  @override
  State<AncestryLibraryItemWidget> createState() => _AncestryLibraryItemWidgetState();
}

class _AncestryLibraryItemWidgetState extends State<AncestryLibraryItemWidget> {
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
              child: Column(children: [
                Text(
                  widget.ancestry.name.localise(context),
                  style: const TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
                ),
                widget.ancestry.linkedSkills.isNotEmpty || widget.ancestry.linkedGroupSkills.isNotEmpty
                    ? buildLinkedSKills(context, widget.ancestry)
                    : const SizedBox.shrink(),
                widget.ancestry.linkedTalents.isNotEmpty || widget.ancestry.linkedGroupTalents.isNotEmpty
                    ? buildLinkedTalents(context, widget.ancestry)
                    : const SizedBox.shrink(),
              ]),
            ),
          ],
        ),
        onTap: widget.onTap,
        onLongPress: widget.onLongPress,
        textColor: Theme.of(context).floatingActionButtonTheme.foregroundColor,
        dense: true,
      ),
    );
  }
}
