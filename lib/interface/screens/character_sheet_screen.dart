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
            columnTypes: const [
              CharacteristicType.name,
              CharacteristicType.name
            ],
            context: context
          ),
          CharacteristicListItem(
            title: "Attributes",
            children: [
              [for (var attribute in widget.character.attributes.values.take(Character.basicAttributesAmount)) attribute.name],
              [for (var attribute in widget.character.attributes.values.take(Character.basicAttributesAmount)) attribute.base.toString()],
              [for (var attribute in widget.character.attributes.values.take(Character.basicAttributesAmount)) attribute.advances.toString()],
              [for (var attribute in widget.character.attributes.values.take(Character.basicAttributesAmount)) attribute.getTotalValue().toString()]
            ],
            context: context
          ),
          CharacteristicListItem(
            children: [
              for (var attribute in widget.character.attributes.values.skip(Character.basicAttributesAmount))
              [attribute.name, attribute.getTotalValue().toString()]
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
              for (var skill in widget.character.skills.values.where((element) => !element.advanced)) [
                skill.name,
                skill.attribute!.name,
                skill.attribute!.getTotalValue().toString(),
                skill.advances.toString(),
                (skill.attribute!.getTotalValue() + skill.advances).toString()
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
                for (var skill in widget.character.skills.values.where((element) => element.advanced)) [
                  skill.name,
                  skill.attribute!.name,
                  skill.attribute!.getTotalValue().toString(),
                  skill.advances.toString(),
                  (skill.attribute!.getTotalValue() + skill.advances).toString()
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
                talent.name,
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
              for (var weapon in widget.character.meleeWeapons) [
                weapon.name,
                weapon.length.toString(),
                weapon.skill!.getSpecialityName()!,
                (weapon.damage + (widget.character.attributes[Character.strengthId]!.getTotalBonus())).toString(),
                weapon.qualities.map((quality) => quality.name).join(", ")
              ],
              for (var weapon in widget.character.rangedWeapons) [
                weapon.name,
                weapon.range.toString(),
                weapon.skill!.getSpecialityName()!,
                (weapon.damage + (weapon.strengthBonus ? (widget.character.attributes[Character.strengthId]!.getTotalBonus()) : 0)).toString(),
                weapon.qualities.map((quality) => quality.name).join(", ")
              ],
            ],
            columnTypes: const [
              CharacteristicType.name,
              CharacteristicType.value,
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
