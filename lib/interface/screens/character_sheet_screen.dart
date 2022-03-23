import 'package:battle_it_out/entities_localisation.dart';
import 'package:battle_it_out/interface/components/list_items.dart';
import 'package:battle_it_out/interface/components/padded_text.dart';
import 'package:battle_it_out/interface/components/table_line.dart';
import 'package:battle_it_out/localisation.dart';
import 'package:battle_it_out/persistence/character.dart';
import 'package:battle_it_out/persistence/entities/skill.dart';
import 'package:flutter/material.dart';

class CharacterSheetScreen extends StatefulWidget {
  const CharacterSheetScreen({Key? key, required this.character}) : super(key: key);

  final Character character;

  @override
  State<CharacterSheetScreen> createState() => _CharacterSheetScreenState();
}

class _CharacterSheetScreenState extends State<CharacterSheetScreen> {
  List<TableLine> createSkills(groupedSkills) {
    List<TableLine> list = [];
    for (var entry in groupedSkills.entries) {
      bool header = true;
      for (Skill skill in entry.value) {
        if (skill.advances > 0 || !skill.isAdvanced()) {
          if (entry.value.length > 1 && header) {
            BaseSkill baseSkill = entry.key;
            header = false;
            list.add(TableLine(children: [
              LocalisedText(baseSkill.name, context),
              LocalisedShortcut(
                  !baseSkill.isAdvanced
                      ? AppLocalizations.of(context).localise(baseSkill.getAttribute()!.shortName)
                      : "",
                  context),
              IntegerText(!baseSkill.isAdvanced ? baseSkill.getAttribute()!.getTotalValue() : null),
              IntegerText(null),
              IntegerText(null),
            ]));
          }
          FontWeight fontWeight = skill.advancable ? FontWeight.bold : FontWeight.normal;
          if (skill.advances > 0 || !skill.isSpecialised()) {
            list.add(TableLine(children: [
              LocalisedText(skill.specialisation ?? skill.name, context,
                  style: TextStyle(
                      fontStyle: skill.isSpecialised() ? FontStyle.italic : FontStyle.normal, fontWeight: fontWeight),
                  padding: skill.isSpecialised() ? const EdgeInsets.only(left: 20) : null),
              LocalisedShortcut(skill.getAttribute()!.shortName, context, style: TextStyle(fontWeight: fontWeight)),
              IntegerText(skill.getAttribute()!.getTotalValue(), style: TextStyle(fontWeight: fontWeight)),
              IntegerText(skill.advances, style: TextStyle(fontWeight: fontWeight)),
              IntegerText(skill.getTotalValue(), style: TextStyle(fontWeight: fontWeight))
            ]));
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
        centerTitle: true,
        title: Text(widget.character.name),
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
          MyCharacteristicListItem(
            title: "Basic skills".localise(context),
              children: createSkills(widget.character.getBasicSkillsGrouped()),
              context: context
          ),
          MyCharacteristicListItem(
              title: "Advanced skills".localise(context),
              children: createSkills(widget.character.getAdvancedSkillsGrouped()),
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
          MyCharacteristicListItem(
            title: "ARMOUR".localise(context),
            children: [for (var armour in widget.character.armour) TableLine(children: [
                LocalisedText(armour.name, context),
                IntegerText(armour.headAP),
                IntegerText(armour.bodyAP),
                IntegerText(armour.leftArmAP),
                IntegerText(armour.rightArmAP),
                IntegerText(armour.leftLegAP),
                IntegerText(armour.rightLegAP)
              ])],
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
            context: context
          )
        ]
      )
    );
  }
}
