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
            child: [
              ["Race: ${widget.character.race.name}"],
              ["Subrace: ${widget.character.subrace.name}"],
              ["Size: ${widget.character.race.size}"],
              ["Profession: ${widget.character.profession.name}"]
            ],
            context: context
          ),
          CharacteristicListItem(
            title: "Attributes",
            isVertical: true,
            child: [
              [for (var attribute in widget.character.attributes.values) attribute.name],
              [for (var attribute in widget.character.attributes.values) (attribute.base + attribute.advances).toString()]
            ],
            context: context
          ),
          const Text("Skills:"),
          Table(
            columnWidths: const {
              0: FlexColumnWidth(),
              1: FixedColumnWidth(48),
              2: FixedColumnWidth(32),
              3: FixedColumnWidth(32)
            },
            children: [
              for (var skill in widget.character.skills.values) TableRow(
                children: [
                  Text(skill.name),
                  Text(skill.attribute!.name),
                  Text((skill.attribute!.base + skill.attribute!.advances).toString()),
                  Text(skill.advances.toString())
                ]
              ),
            ],
          ),
          const Text("Talents:"),
          Table(
            columnWidths: const {
              0: FlexColumnWidth(),
              1: FixedColumnWidth(32)
            },
            children: [
              for (var talent in widget.character.talents.values) TableRow(
                  children: [
                    Text(talent.name),
                    Text(talent.currentLvl.toString())
                  ]
              ),
            ],
          ),
          const Text("Armour:"),
          Table(
            columnWidths: const {
              0: FlexColumnWidth(),
              1: FixedColumnWidth(32),
              2: FixedColumnWidth(32),
              3: FixedColumnWidth(32),
              4: FixedColumnWidth(32),
              5: FixedColumnWidth(32),
              6: FixedColumnWidth(32)
            },
            children: [
              for (var armour in widget.character.armour) TableRow(
                children: [
                  Text(armour.name),
                  Text(armour.headAP.toString()),
                  Text(armour.bodyAP.toString()),
                  Text(armour.leftArmAP.toString()),
                  Text(armour.rightArmAP.toString()),
                  Text(armour.leftLegAP.toString()),
                  Text(armour.rightLegAP.toString())
                ]
              )
            ],
          ),
          const Text("Weapons:"),
          Column(
            children: [
              for (var weapon in widget.character.meleeWeapons) Text(weapon.name),
              for (var weapon in widget.character.rangedWeapons) Text(weapon.name)
            ],
          )
        ]
      )
    );
  }
}
