import 'package:battle_it_out/entities_localisation.dart';
import 'package:battle_it_out/interface/components/alert.dart';
import 'package:battle_it_out/interface/components/list_items.dart';
import 'package:battle_it_out/interface/components/padded_text.dart';
import 'package:battle_it_out/interface/components/table_line.dart';
import 'package:battle_it_out/persistence/character.dart';
import 'package:battle_it_out/persistence/entities/attribute.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';
import 'package:battle_it_out/persistence/entities/melee_weapon.dart';
import 'package:battle_it_out/persistence/entities/ranged_weapon.dart';
import 'package:battle_it_out/persistence/entities/skill.dart';
import 'package:battle_it_out/persistence/entities/talent.dart';
import 'package:battle_it_out/persistence/entities/weapon_length.dart';

class CharacterSheetScreen extends StatefulWidget {
  const CharacterSheetScreen({Key? key, required this.character}) : super(key: key);
  final Character character;

  @override
  State<CharacterSheetScreen> createState() => _CharacterSheetScreenState();
}

class _CharacterSheetScreenState extends State<CharacterSheetScreen> {
  bool editMode = false;

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
                    defaultStyle: TextStyle(fontWeight: skill.advancable ? FontWeight.bold : FontWeight.normal),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(widget.character.name),
        ),
        body: ListView(padding: const EdgeInsets.all(12), children: [
          SingleEntitiesTable(
              children: [
                TableLine(children: [
                  LocalisedText("RACE", context),
                  LocalisedText(widget.character.race?.getLocalName(context) ?? "", context, editMode: editMode)
                ]),
                TableLine(children: [
                  LocalisedText("SIZE", context),
                  LocalisedText(widget.character.race?.size.name ?? "", context, editMode: editMode)
                ]),
                TableLine(children: [
                  LocalisedText("PROFESSION", context),
                  LocalisedText(widget.character.profession?.getLocalName(context) ?? "", context, editMode: editMode)
                ]),
              ],
              onLongPress: () {
                debugPrint("Changing edit mode");
                setState(() {
                  if (kDebugMode) {
                    print(editMode);
                  }
                  editMode = !editMode;
                  if (kDebugMode) {
                    print(editMode);
                  }
                });
              },
              context: context),
          SingleEntitiesTable(
              title: LocalisedText("ATTRIBUTES", context,
                  style: const TextStyle(fontSize: 24.0), textAlign: TextAlign.center),
              children: [
                TableLine(children: [
                  for (Attribute attribute in widget.character.attributes.values.where((attr) => attr.importance == 0))
                    LocalisedText(attribute.shortName, context, textAlign: TextAlign.center)
                ]),
                TableLine(children: [
                  for (Attribute attribute in widget.character.attributes.values.where((attr) => attr.importance == 0))
                    IntegerText(attribute.base,
                        editMode: editMode,
                        onChange: (int number) => {
                              setState(() {
                                widget.character.attributes[attribute.id]!.base = number;
                              }),
                    })
                ]),
                TableLine(children: [
                  for (Attribute attribute in widget.character.attributes.values.where((attr) => attr.importance == 0))
                    IntegerText(attribute.advances, editMode: editMode)
                ]),
                TableLine(children: [
                  for (Attribute attribute in widget.character.attributes.values.where((attr) => attr.importance == 0))
                    IntegerText(attribute.getTotalValue())
                ])
              ],
              onLongPress: () {
                setState(() {
                  editMode = !editMode;
                });
              },
              context: context),
          SingleEntitiesTable(children: [
            for (var attribute in widget.character.attributes.values.where((attr) => attr.importance > 0))
              TableLine(children: [
                LocalisedText(attribute.name, context),
                IntegerText(attribute.getTotalValue(), editMode: editMode)
              ])
          ], context: context),
          GroupedEntitiesTable(
              title: LocalisedText("BASIC_SKILLS", context,
                  style: const TextStyle(fontSize: 24.0), textAlign: TextAlign.center),
              children: createSkillsTable(widget.character.getBasicSkillsGrouped()),
              context: context),
          GroupedEntitiesTable(
              title: LocalisedText("ADVANCED_SKILLS", context,
                  style: const TextStyle(fontSize: 24.0), textAlign: TextAlign.center),
              children: createSkillsTable(widget.character.getAdvancedSkillsGrouped()),
              context: context),
          GroupedEntitiesTable(
              title: LocalisedText("TALENTS", context,
                  style: const TextStyle(fontSize: 24.0), textAlign: TextAlign.center),
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
                                  TextStyle(fontWeight: talent.advancable ? FontWeight.bold : FontWeight.normal),
                              children: [
                                LocalisedText(talent.specialisation ?? talent.name, context,
                                    padding: talent.isSpecialised() ? const EdgeInsets.only(left: 20) : null),
                                LocalisedText(
                                    talent.tests.map((quality) => quality.getLocalName(context)).join(",\n"), context),
                                IntegerText(talent.currentLvl, editMode: editMode),
                                IntegerText(talent.getMaxLvl())
                              ])
                      ])
              ],
              context: context),
          SingleEntitiesTable(
              title:
                  LocalisedText("ARMOUR", context, style: const TextStyle(fontSize: 24.0), textAlign: TextAlign.center),
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
              title: LocalisedText("MELEE_WEAPONS", context,
                  style: const TextStyle(fontSize: 24.0), textAlign: TextAlign.center),
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
                            LocalisedText("${weapon.getTotalDamage()} + SL", context, textAlign: TextAlign.center),
                            LocalisedText(
                                weapon.qualities.map((quality) => quality.name.localise(context)).join(", "), context)
                          ])
                      ])
              ],
              context: context),
          GroupedEntitiesTable(
              title: LocalisedText("RANGED_WEAPONS", context,
                  style: const TextStyle(fontSize: 24.0), textAlign: TextAlign.center),
              children: [
                for (MapEntry<Skill, List<RangedWeapon>> entry in widget.character.getRangedWeaponsGrouped().entries)
                  TableSubsection(
                      header: TableLine(children: [
                        LocalisedText(entry.key.specialisation!, context),
                        IntegerText(null),
                        IntegerText(null),
                        IntegerText(null),
                      ]),
                      children: [
                        for (var weapon in entry.value)
                          TableLine(children: [
                            LocalisedText(weapon.name, context, padding: const EdgeInsets.only(left: 20)),
                            IntegerText(weapon.range),
                            LocalisedText("${weapon.getTotalDamage()} + SL", context, textAlign: TextAlign.center),
                            LocalisedText(
                                weapon.qualities.map((quality) => quality.name.localise(context)).join(", "), context)
                          ])
                      ])
              ],
              onLongPress: () {
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
              context: context)
        ]));
  }
}
