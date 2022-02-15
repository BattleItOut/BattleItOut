import 'package:battle_it_out/interface/components/list_items.dart';
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
              ["Race:", widget.character.race.name],
              ["Subrace:", widget.character.subrace.name],
              ["Size:", widget.character.race.size.toString()],
              ["Profession:", widget.character.profession.name]
            ],
            context: context
          ),
          // TODO: get rid of magic numbers and don't convert iterable to list
          CharacteristicListItem(
            title: "Attributes",
            isVertical: true,
            children: [
              [for (var attribute in widget.character.attributes.values.take(10)) attribute.name],
              [for (var attribute in widget.character.attributes.values.take(10)) (attribute.base + attribute.advances).toString()]
            ],
            context: context
          ),
          CharacteristicListItem(
            children: [
              for (var attribute in widget.character.attributes.values.toList().reversed.take(3))
              [attribute.name, (attribute.base + attribute.advances).toString()]
            ],
            columnTypes: const [
              CharacteristicType.name,
              CharacteristicType.value
            ],
            context: context
          ),
          CharacteristicListItem(
            title: "Skills",
            children: [
              for (var skill in widget.character.skills.values) [
                skill.name,
                skill.attribute!.name,
                (skill.attribute!.base + skill.attribute!.advances).toString(),
                skill.advances.toString()
              ]
            ],
            columnTypes: const [
              CharacteristicType.name,
              CharacteristicType.shortcut,
              CharacteristicType.value,
              CharacteristicType.value
            ],
            context: context
          ),
          CharacteristicListItem(
            title: "Talents",
            children: [
              for (var talent in widget.character.talents.values) [
                talent.name,
                talent.currentLvl.toString()
              ]
            ],
            columnTypes: const [
              CharacteristicType.name,
              CharacteristicType.value
            ],
            context: context
          ),
          CharacteristicListItem(
            title: "Armour",
            children: [
              for (var armour in widget.character.armour) [
                armour.name,
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
              for (var weapon in widget.character.meleeWeapons) [weapon.name],
              for (var weapon in widget.character.rangedWeapons) [weapon.name]
            ],
            context: context
          )
        ]
      )
    );
  }
}
