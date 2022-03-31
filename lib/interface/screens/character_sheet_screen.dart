import 'package:battle_it_out/entities_localisation.dart';
import 'package:battle_it_out/interface/components/alert.dart';
import 'package:battle_it_out/interface/components/list_items.dart';
import 'package:battle_it_out/persistence/character.dart';
import 'package:battle_it_out/persistence/entities/melee_weapon.dart';
import 'package:battle_it_out/persistence/entities/weapon_length.dart';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

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
        centerTitle: true,
        title: Text(widget.character.name),
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          CharacteristicListItem(
            children: [
              ["RACE".localise(context), widget.character.race?.getLocalName(context) ?? ""],
              ["SIZE".localise(context), widget.character.race?.size.name.localise(context) ?? ""],
              ["PROFESSION".localise(context), widget.character.profession?.getLocalName(context) ?? ""]
            ],
            columnTypes: const [
              CharacteristicType.name,
              CharacteristicType.name
            ],
            context: context
          ),
          CharacteristicListItem(
            title: "ATTRIBUTES".localise(context),
            children: (widget.character.attributes.isNotEmpty) ? [
              [for (var attribute in widget.character.attributes.values.where((attr) => attr.importance == 0)) attribute.shortName.localise(context)],
              [for (var attribute in widget.character.attributes.values.where((attr) => attr.importance == 0)) attribute.base.toString()],
              [for (var attribute in widget.character.attributes.values.where((attr) => attr.importance == 0)) attribute.advances.toString()],
              [for (var attribute in widget.character.attributes.values.where((attr) => attr.importance == 0)) attribute.getTotalValue().toString()]
            ] : [],
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
            title: "BASIC_SKILLS".localise(context),
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
              title: "ADVANCED_SKILLS".localise(context),
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
            title: "TALENTS".localise(context),
            children: [
              for (var talent in widget.character.talents.values) [
                talent.name.localise(context),
                talent.tests.map((quality) => quality.getLocalName(context)).join(",\n"),
                talent.currentLvl.toString(),
                talent.getMaxLvl()?.toString() ?? ""
              ]
            ],
            columnTypes: const [
              CharacteristicType.name,
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
                weapon.getTotalDamage().toString(),
                weapon.qualities.map((quality) => quality.name.localise(context)).join(", ")
              ],
              for (var weapon in widget.character.rangedWeapons) [
                weapon.name.localise(context),
                weapon.getRange().toString(),
                weapon.skill!.specialisation!.localise(context),
                weapon.getTotalDamage().toString(),
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
            doOnLongPress: () {
              String weaponName = "";
              int weaponDamage = 0;
              showAlert(
                "ADD_WEAPON".localise(context),
                [
                  Tuple2((value) { weaponName = value; }, String),
                  Tuple2((value) { weaponDamage = int.parse(value); }, int)
                ],
                () {
                  Navigator.of(context).pop();
                  setState(() {
                    widget.character.meleeWeapons.add(MeleeWeapon(
                      id: 0,
                      name: weaponName,
                      length: WeaponLength(name: "LONG".localise(context)),
                      damage: weaponDamage,
                      skill: null)
                    );
                  });
                },
                context
              );
            },
            context: context
          )
        ]
      )
    );
  }
}
