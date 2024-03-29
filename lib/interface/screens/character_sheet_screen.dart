import 'package:battle_it_out/entities_localisation.dart';
import 'package:battle_it_out/interface/components/list_items.dart';
import 'package:battle_it_out/interface/components/padded_text.dart';
import 'package:battle_it_out/interface/components/table_line.dart';
import 'package:battle_it_out/persistence/character.dart';
import 'package:battle_it_out/persistence/item/ammunition.dart';
import 'package:battle_it_out/persistence/item/item.dart';
import 'package:battle_it_out/persistence/item/melee_weapon.dart';
import 'package:battle_it_out/persistence/item/ranged_weapon.dart';
import 'package:battle_it_out/persistence/skill/skill.dart';
import 'package:battle_it_out/persistence/skill/skill_base.dart';
import 'package:battle_it_out/persistence/talent/talent.dart';
import 'package:battle_it_out/persistence/talent/talent_base.dart';
import 'package:flutter/material.dart';

class CharacterSheetScreen extends StatefulWidget {
  final Character character;

  const CharacterSheetScreen({super.key, required this.character});

  @override
  State<CharacterSheetScreen> createState() => _CharacterSheetScreenState();
}

class _CharacterSheetScreenState extends State<CharacterSheetScreen> {
  SingleEntitiesTable buildMainTable(BuildContext context) {
    List<TableLine> children = [
      TableLine(
        children: [LocalisedText("SIZE", context), LocalisedText(widget.character.getSize()?.name ?? "", context)],
      )
    ];
    if (widget.character.subrace != null) {
      children.add(TableLine(children: [
        LocalisedText("RACE", context),
        LocalisedText(widget.character.subrace?.getLocalName(context) ?? "", context)
      ]));
    }
    if (widget.character.subrace != null) {
      children.add(TableLine(children: [
        LocalisedText("PROFESSION", context),
        LocalisedText(widget.character.profession?.getLocalName(context) ?? "", context)
      ]));
    }

    return SingleEntitiesTable(children: children, context: context);
  }

  List<TableSubsection> createSkillsTable(Map<BaseSkill, List<Skill>> groupedMap) {
    return [
      for (MapEntry<BaseSkill, List<Skill>> entry in groupedMap.entries)
        TableSubsection(
            header: TableLine(children: [
              LocalisedText(entry.key.name, context),
              LocalisedShortcut(entry.key.getAttribute()!.shortName, context, hidden: entry.key.advanced),
              IntegerText(entry.key.getAttribute()!.getTotalValue(), hidden: entry.key.advanced),
              IntegerText(null),
              IntegerText(null),
            ]),
            headerHidden: !entry.key.grouped,
            children: [
              for (Skill skill in entry.value.where((Skill skill) => skill.advances > 0 || !skill.isSpecialised()))
                TableLine(
                    defaultStyle: TextStyle(fontWeight: skill.canAdvance ? FontWeight.bold : FontWeight.normal),
                    children: [
                      LocalisedText(skill.specialisation ?? skill.name, context,
                          style: TextStyle(fontStyle: skill.earning ? FontStyle.italic : FontStyle.normal),
                          padding: skill.isSpecialised() ? const EdgeInsets.only(left: 20) : null),
                      LocalisedShortcut(skill.getAttribute()!.shortName, context),
                      IntegerText(skill.getAttribute()!.getTotalValue()),
                      IntegerText(skill.advances),
                      IntegerText(skill.getTotalValue())
                    ])
            ])
    ];
  }

  List<TableLine> createRangedWeapons(List<RangedWeapon> weapons, BuildContext context) {
    List<TableLine> outputList = [];
    for (RangedWeapon weapon in weapons) {
      outputList.add(TableLine(children: [
        LocalisedText(weapon.name, context, padding: const EdgeInsets.only(left: 20)),
        IntegerText(null),
        IntegerText(null),
        const PaddedText(""),
        PaddedText(weapon.qualities.map((quality) => quality.name.localise(context)).join(", "))
      ]));
      for (Ammunition ammo in weapon.ammunition) {
        outputList.add(TableLine(children: [
          LocalisedText(ammo.name, context, padding: const EdgeInsets.only(left: 40)),
          IntegerText(ammo.amount),
          IntegerText(weapon.getRange(ammo)),
          PaddedText("${weapon.getTotalDamage(ammo)} + SL", textAlign: TextAlign.center),
          PaddedText(ammo.qualities.map((quality) => quality.name.localise(context)).join(", "))
        ]));
      }
    }
    return outputList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(widget.character.name),
        ),
        body: ListView(padding: const EdgeInsets.all(12), children: [
          buildMainTable(context),
          SingleEntitiesTable(
              title: LocalisedText("ATTRIBUTES", context, style: const TextStyle(fontSize: 24.0)),
              children: widget.character.attributes.isEmpty
                  ? []
                  : [
                      TableLine(children: [
                        for (var attribute in widget.character.attributes.where((attr) => attr.importance == 0))
                          LocalisedText(attribute.shortName, context, textAlign: TextAlign.center)
                      ]),
                      TableLine(children: [
                        for (var attribute in widget.character.attributes.where((attr) => attr.importance == 0))
                          IntegerText(attribute.base)
                      ]),
                      TableLine(children: [
                        for (var attribute in widget.character.attributes.where((attr) => attr.importance == 0))
                          IntegerText(attribute.advances)
                      ]),
                      TableLine(children: [
                        for (var attribute in widget.character.attributes.where((attr) => attr.importance == 0))
                          IntegerText(attribute.getTotalValue())
                      ])
                    ],
              context: context),
          SingleEntitiesTable(children: [
            for (var attribute in widget.character.attributes.where((attr) => attr.importance > 0))
              TableLine(children: [LocalisedText(attribute.name, context), IntegerText(attribute.getTotalValue())])
          ], context: context),
          GroupedEntitiesTable(
              title: LocalisedText("BASIC_SKILLS", context, style: const TextStyle(fontSize: 24.0)),
              children: createSkillsTable(widget.character.getBasicSkillsGrouped()),
              context: context),
          GroupedEntitiesTable(
              title: LocalisedText("ADVANCED_SKILLS", context, style: const TextStyle(fontSize: 24.0)),
              children: createSkillsTable(widget.character.getAdvancedSkillsGrouped()),
              context: context),
          GroupedEntitiesTable(
              title: LocalisedText("TALENTS", context, style: const TextStyle(fontSize: 24.0)),
              children: [
                for (MapEntry<BaseTalent, List<Talent>> entry in widget.character.getTalentsGrouped().entries)
                  TableSubsection(
                      header: TableLine(children: [
                        LocalisedText(entry.key.name, context),
                        IntegerText(null),
                        IntegerText(null),
                        IntegerText(null)
                      ]),
                      headerHidden: !entry.key.grouped,
                      children: [
                        for (Talent talent in entry.value)
                          TableLine(
                              defaultStyle:
                                  TextStyle(fontWeight: talent.canAdvance ? FontWeight.bold : FontWeight.normal),
                              children: [
                                LocalisedText(talent.specialisation ?? talent.name, context,
                                    padding: talent.isSpecialised() ? const EdgeInsets.only(left: 20) : null),
                                PaddedText(talent.tests.map((quality) => quality.getLocalName(context)).join(",\n")),
                                IntegerText(talent.currentLvl),
                                IntegerText(talent.getMaxLvl())
                              ])
                      ])
              ],
              context: context),
          SingleEntitiesTable(
              title: LocalisedText("ARMOUR", context, style: const TextStyle(fontSize: 24.0)),
              children: [
                for (var armour in widget.character.armour)
                  TableLine(children: [
                    LocalisedText(armour.name, context),
                    IntegerText(armour.headAP),
                    IntegerText(armour.bodyAP),
                    IntegerText(armour.leftArmAP),
                    IntegerText(armour.rightArmAP),
                    IntegerText(armour.leftLegAP),
                    IntegerText(armour.rightLegAP)
                  ])
              ],
              context: context),
          GroupedEntitiesTable(
              title: LocalisedText("MELEE_WEAPONS", context, style: const TextStyle(fontSize: 24.0)),
              children: [
                for (MapEntry<Skill, List<MeleeWeapon>> entry in widget.character.getMeleeWeaponsGrouped().entries)
                  TableSubsection(
                      header: TableLine(children: [
                        LocalisedText(entry.key.specialisation!, context),
                        IntegerText(null),
                        IntegerText(null),
                        IntegerText(null),
                      ]),
                      children: [
                        for (MeleeWeapon weapon in entry.value)
                          TableLine(children: [
                            LocalisedText(weapon.name, context, padding: const EdgeInsets.only(left: 20)),
                            LocalisedText(weapon.length.name, context, textAlign: TextAlign.center),
                            PaddedText("${weapon.getTotalDamage()} + SL", textAlign: TextAlign.center),
                            PaddedText(weapon.qualities.map((quality) => quality.name.localise(context)).join(", "))
                          ])
                      ])
              ],
              context: context),
          GroupedEntitiesTable(
              title: LocalisedText("RANGED_WEAPONS", context, style: const TextStyle(fontSize: 24.0)),
              children: [
                for (MapEntry<Skill, List<RangedWeapon>> entry in widget.character.getRangedWeaponsGrouped().entries)
                  TableSubsection(
                      header: TableLine(children: [
                        LocalisedText(entry.key.specialisation!, context),
                        IntegerText(null),
                        IntegerText(null),
                        const PaddedText(""),
                        const PaddedText(""),
                      ]),
                      children: createRangedWeapons(entry.value, context))
              ],
              context: context),
          GroupedEntitiesTable(
              title: LocalisedText("ITEMS", context, style: const TextStyle(fontSize: 24.0)),
              children: [
                for (MapEntry<String, Map<Item, int>> entry in widget.character.getCommonItemsGrouped().entries)
                  TableSubsection(
                    header: TableLine(children: [
                      IntegerText(null),
                      LocalisedText(entry.key, context, style: const TextStyle(fontWeight: FontWeight.bold)),
                      IntegerText(null),
                      const PaddedText(""),
                    ]),
                    headerHidden: entry.key == "NONE",
                    children: [
                      for (MapEntry<Item, int> secondaryEntry in entry.value.entries)
                        TableLine(children: [
                          IntegerText(secondaryEntry.value),
                          LocalisedText(secondaryEntry.key.name, context),
                          IntegerText(secondaryEntry.key.encumbrance),
                          PaddedText(
                              secondaryEntry.key.qualities.map((quality) => quality.name.localise(context)).join(", "))
                        ])
                    ],
                  )
              ],
              context: context)
        ]));
  }
}
