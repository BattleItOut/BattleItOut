import 'package:battle_it_out/entities_localisation.dart';
import 'package:battle_it_out/interface/components/list_items.dart';
import 'package:battle_it_out/localisation.dart';
import 'package:battle_it_out/persistence/character.dart';
import 'package:flutter/material.dart';

class CharacterSheetScreen extends StatefulWidget {
  const CharacterSheetScreen({Key? key, required this.character}) : super(key: key);

  final Character character;

  @override
  State<CharacterSheetScreen> createState() => _CharacterSheetScreenState();
}

class _CharacterSheetScreenState extends State<CharacterSheetScreen> {
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
              ["Race:", widget.character.race.getLocalName(context)],
              ["Size:", widget.character.race.size.name.localise(context)],
              ["Profession:", widget.character.profession.getLocalName(context)]
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
            children: [
              for (var skill in widget.character.skills.values.where((element) => !element.isAdvanced())) [
                skill.name.localise(context),
                skill.getAttribute()!.shortName.localise(context),
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
                  skill.name.localise(context),
                  skill.getAttribute()!.shortName.localise(context),
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
            title: "Armour",
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
            title: "Weapons",
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
