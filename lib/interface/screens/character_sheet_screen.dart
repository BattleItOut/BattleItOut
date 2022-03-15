import 'package:battle_it_out/entities_localisation.dart';
import 'package:battle_it_out/interface/components/list_items.dart';
import 'package:battle_it_out/persistence/character.dart';
import 'package:flutter/material.dart';

class CharacterSheetScreen extends StatefulWidget {
  const CharacterSheetScreen({Key? key, required this.character}) : super(key: key);

  final Character character;

  @override
  State<CharacterSheetScreen> createState() => _CharacterSheetScreenState();
}

  List<List<String>> createSkills(groupedSkills) {
    List<List<String>> list = [];
    for (var entry in groupedSkills.entries) {
      if (entry.value.length == 1) {
        if (entry.value.first.advances > 0) {
          list.add([
            AppLocalizations.of(context).localise(entry.value.first.name),
            "",
            AppLocalizations.of(context).localise(entry.value.first.getAttribute()!.shortName),
            entry.value.first.getAttribute()!.getTotalValue().toString(),
            entry.value.first.advances.toString(),
            entry.value.first.getTotalValue().toString()
          ]);
        }
      } else {
        list.add([
          AppLocalizations.of(context).localise(entry.key),
          "",
          !entry.value.first.isAdvanced() ? AppLocalizations.of(context).localise(entry.value.first.getAttribute()!.shortName) : "",
          !entry.value.first.isAdvanced() ? entry.value.first.getAttribute()!.getTotalValue().toString() : "",
          "",
          ""
        ]);
        for (var skill in entry.value) {
          if (skill.advances > 0) {
            list.add([
              "",
              AppLocalizations.of(context).localise(skill.specialisation!),
              AppLocalizations.of(context).localise(skill.getAttribute()!.shortName),
              skill.getAttribute()!.getTotalValue().toString(),
              skill.advances.toString(),
              skill.getTotalValue().toString()
            ]);
          }
        }
      }
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(widget.character.name)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          CharacteristicListItem(
            children: [
              ["RACE".localise(context), widget.character.race.getLocalName(context)],
              ["SIZE".localise(context), widget.character.race.size.name.localise(context)],
              ["PROFESSION".localise(context), widget.character.profession.getLocalName(context)]
            ],
            columnTypes: const [
              CharacteristicType.name,
              CharacteristicType.name
            ],
            context: context
          ),
          CharacteristicListItem(
            title: "ATTRIBUTES".localise(context),
            children: [
              [for (var attribute in widget.character.attributes.values.where((attr) => attr.importance == 0)) attribute.shortName.localise(context)],
              [for (var attribute in widget.character.attributes.values.where((attr) => attr.importance == 0)) attribute.base.toString()],
              [for (var attribute in widget.character.attributes.values.where((attr) => attr.importance == 0)) attribute.advances.toString()],
              [for (var attribute in widget.character.attributes.values.where((attr) => attr.importance == 0)) attribute.getTotalValue().toString()]
            ],
            context: context
          ),
          CharacteristicListItem(
            children: [
              for (var attribute in widget.character.attributes.values.where((attr) => attr.importance > 0))
              [attribute.name.localise(context), attribute.getTotalValue().toString()]
            ],
            columnTypes: const [
              CharacteristicType.name,
              CharacteristicType.value
            ],
            context: context
          ),
          CharacteristicListItem(
            title: "Basic skills",
              children: createSkills(widget.character.getBasicSkillsGrouped()),
              columnTypes: const [
                CharacteristicType.name,
                CharacteristicType.name,
                CharacteristicType.shortcut,
                CharacteristicType.value,
                CharacteristicType.value,
                CharacteristicType.value
              ],
              context: context
          ),
          CharacteristicListItem(
              title: "Advanced skills",
              children: createSkills(widget.character.getAdvancedSkillsGrouped()),
              columnTypes: const [
                CharacteristicType.name,
                CharacteristicType.name,
                CharacteristicType.shortcut,
                CharacteristicType.value,
                CharacteristicType.value,
                CharacteristicType.value
              ],
              context: context
          ),
          CharacteristicListItem(
            title: "TALENTS".localise(context),
            children: [
              for (var talent in widget.character.talents.values) [
                talent.name.localise(context),
                talent.currentLvl.toString(),
                talent.getMaxLvl()?.toString() ?? ""
              ]
            ],
            columnTypes: const [
              CharacteristicType.name,
              CharacteristicType.value,
              CharacteristicType.value
            ],
            context: context
          ),
          CharacteristicListItem(
            title: "ARMOUR".localise(context),
            children: [
              for (var armour in widget.character.armour) [
                armour.name.localise(context),
                armour.headAP.toString(),
                armour.bodyAP.toString(),
                armour.leftArmAP.toString(),
                armour.rightArmAP.toString(),
                armour.leftLegAP.toString(),
                armour.rightLegAP.toString()
              ]
            ],
            columnTypes: const [
              CharacteristicType.name,
              CharacteristicType.value,
              CharacteristicType.value,
              CharacteristicType.value,
              CharacteristicType.value,
              CharacteristicType.value,
              CharacteristicType.value
            ],
            context: context
          ),
          CharacteristicListItem(
            title: "WEAPONS".localise(context),
            children: [
              for (var weapon in widget.character.meleeWeapons) [
                weapon.name.localise(context),
                weapon.length.name.localise(context),
                weapon.skill!.specialisation!.localise(context),
                (weapon.damage + (widget.character.attributes[Character.strengthId]!.getTotalBonus())).toString(),
                weapon.qualities.map((quality) => quality.name.localise(context)).join(", ")
              ],
              for (var weapon in widget.character.rangedWeapons) [
                weapon.name.localise(context),
                weapon.range.toString(),
                weapon.skill!.specialisation!.localise(context),
                (weapon.damage + (weapon.strengthBonus ? (widget.character.attributes[Character.strengthId]!.getTotalBonus()) : 0)).toString(),
                weapon.qualities.map((quality) => quality.name.localise(context)).join(", ")
              ],
            ],
            columnTypes: const [
              CharacteristicType.name,
              CharacteristicType.name,
              CharacteristicType.name,
              CharacteristicType.value,
              CharacteristicType.name
            ],
            context: context
          )
        ]
      )
    );
  }
}
