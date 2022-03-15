import 'package:battle_it_out/interface/components/list_items.dart';
import 'package:battle_it_out/localisation.dart';
import 'package:battle_it_out/persistence/character.dart';
import 'package:battle_it_out/persistence/entities/profession.dart';
import 'package:battle_it_out/persistence/entities/race.dart';
import 'package:flutter/material.dart';

class CharacterSheetScreen extends StatefulWidget {
  const CharacterSheetScreen({Key? key, required this.character}) : super(key: key);

  final Character character;

  @override
  State<CharacterSheetScreen> createState() => _CharacterSheetScreenState();
}

class _CharacterSheetScreenState extends State<CharacterSheetScreen> {
  String getRaceNameLocalised(Race race) {
    if (race.subrace != null && race.name != race.subrace!.name) {
      return "${AppLocalizations.of(context).localise(race.name)} (${AppLocalizations.of(context).localise(race.subrace!.name)})";
    } else {
      return AppLocalizations.of(context).localise(race.name);
    }
  }

  String getProfessionNameLocalised(Profession profession) {
    if (profession.career != null) {
      return "${AppLocalizations.of(context).localise(profession.name)} (${AppLocalizations.of(context).localise(profession.career!.name)})";
    } else {
      return AppLocalizations.of(context).localise(profession.name);
    }
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
              ["Race:", getRaceNameLocalised(widget.character.race)],
              ["Size:", AppLocalizations.of(context).localise(widget.character.race.size.name)],
              ["Profession:", getProfessionNameLocalised(widget.character.profession)]
            ],
            columnTypes: const [
              CharacteristicType.name,
              CharacteristicType.name
            ],
            context: context
          ),
          CharacteristicListItem(
            title: "Attributes",
            children: [
              [for (var attribute in widget.character.attributes.values.where((attr) => attr.importance == 0)) AppLocalizations.of(context).localise(attribute.shortName)],
              [for (var attribute in widget.character.attributes.values.where((attr) => attr.importance == 0)) attribute.base.toString()],
              [for (var attribute in widget.character.attributes.values.where((attr) => attr.importance == 0)) attribute.advances.toString()],
              [for (var attribute in widget.character.attributes.values.where((attr) => attr.importance == 0)) attribute.getTotalValue().toString()]
            ],
            context: context
          ),
          CharacteristicListItem(
            children: [
              for (var attribute in widget.character.attributes.values.where((attr) => attr.importance > 0))
              [AppLocalizations.of(context).localise(attribute.name), attribute.getTotalValue().toString()]
            ],
            columnTypes: const [
              CharacteristicType.name,
              CharacteristicType.value
            ],
            context: context
          ),
          CharacteristicListItem(
            title: "Basic skills",
            children: [
              for (var skill in widget.character.skills.values.where((element) => !element.isAdvanced())) [
                AppLocalizations.of(context).localise(skill.name),
                AppLocalizations.of(context).localise(skill.getAttribute()!.shortName),
                skill.getAttribute()!.getTotalValue().toString(),
                skill.advances.toString(),
                skill.getTotalValue().toString()
              ]
            ],
            columnTypes: const [
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
              children: [
                for (var skill in widget.character.skills.values.where((element) => element.isAdvanced())) [
                  AppLocalizations.of(context).localise(skill.name),
                  AppLocalizations.of(context).localise(skill.getAttribute()!.shortName),
                  skill.getAttribute()!.getTotalValue().toString(),
                  skill.advances.toString(),
                  skill.getTotalValue().toString()
                ]
              ],
              columnTypes: const [
                CharacteristicType.name,
                CharacteristicType.shortcut,
                CharacteristicType.value,
                CharacteristicType.value,
                CharacteristicType.value
              ],
              context: context
          ),
          CharacteristicListItem(
            title: "Talents",
            children: [
              for (var talent in widget.character.talents.values) [
                AppLocalizations.of(context).localise(talent.name),
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
            title: "Armour",
            children: [
              for (var armour in widget.character.armour) [
                AppLocalizations.of(context).localise(armour.name),
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
            title: "Weapons",
            children: [
              for (var weapon in widget.character.meleeWeapons) [
                AppLocalizations.of(context).localise(weapon.name),
                AppLocalizations.of(context).localise(weapon.length.name),
                AppLocalizations.of(context).localise(weapon.skill!.specialisation!),
                (weapon.damage + (widget.character.attributes[Character.strengthId]!.getTotalBonus())).toString(),
                weapon.qualities.map((quality) => AppLocalizations.of(context).localise(quality.name)).join(", ")
              ],
              for (var weapon in widget.character.rangedWeapons) [
                AppLocalizations.of(context).localise(weapon.name),
                weapon.range.toString(),
                AppLocalizations.of(context).localise(weapon.skill!.specialisation!),
                (weapon.damage + (weapon.strengthBonus ? (widget.character.attributes[Character.strengthId]!.getTotalBonus()) : 0)).toString(),
                weapon.qualities.map((quality) => AppLocalizations.of(context).localise(quality.name)).join(", ")
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
