import 'package:battle_it_out/persistence/entities/armour.dart';
import 'package:battle_it_out/persistence/entities/attribute.dart';
import 'package:battle_it_out/persistence/entities/item.dart';
import 'package:battle_it_out/persistence/entities/melee_weapon.dart';
import 'package:battle_it_out/persistence/entities/profession.dart';
import 'package:battle_it_out/persistence/entities/race.dart';
import 'package:battle_it_out/persistence/entities/ranged_weapon.dart';
import 'package:battle_it_out/persistence/entities/skill.dart';
import 'package:battle_it_out/persistence/entities/talent.dart';
import 'package:flutter/foundation.dart';

class Character {
  String name;
  Race? race;
  Profession? profession;
  Map<int, Attribute> attributes;
  Map<int, Skill> skills;
  Map<int, Talent> talents = {};

  List<Item> items = [];
  int? initiative;
  // List<Trait> traits;

  Character(
      {required this.name,
      this.race,
      this.profession,
      this.attributes = const {},
      this.skills = const {},
      this.talents = const {},
      List<Item> items = const []}) {
    this.items.addAll(items);
  }

  static Character from(Character character) {
    var newInstance = Character(
        name: character.name,
        race: character.race,
        profession: character.profession,
        attributes: character.attributes);
    newInstance.skills = character.skills;
    newInstance.talents = character.talents;
    newInstance.initiative = character.initiative;
    return newInstance;
  }

  void addItem(Item item) {
    int index = items.indexOf(item);
    if (index == -1) {
      items.add(item);
    } else {
      items[index].count += 1;
    }
  }

  void addItems(List<Item> items) {
    for (Item item in items) {
      addItem(item);
    }
  }

  // List getters
  List<Attribute> getAttributes() {
    return List.of(attributes.values);
  }

  Map<BaseSkill, List<Skill>> getBasicSkillsGrouped() {
    Map<BaseSkill, List<Skill>> output = {};
    for (var skill in skills.values.where((skill) => !skill.isAdvanced())) {
      var category = skill.baseSkill!;
      if (output.containsKey(category)) {
        output[category]!.add(skill);
      } else {
        output[category] = [skill];
      }
    }
    return output;
  }

  Map<BaseSkill, List<Skill>> getAdvancedSkillsGrouped() {
    Map<BaseSkill, List<Skill>> output = {};
    for (var skill in skills.values.where((skill) => skill.isAdvanced())) {
      var category = skill.baseSkill!;
      if (output.containsKey(category)) {
        output[category]!.add(skill);
      } else {
        output[category] = [skill];
      }
    }
    return output;
  }

  Map<BaseTalent, List<Talent>> getTalentsGrouped() {
    Map<BaseTalent, List<Talent>> output = {};
    for (var talent in talents.values) {
      var category = talent.baseTalent!;
      if (output.containsKey(category)) {
        output[category]!.add(talent);
      } else {
        output[category] = [talent];
      }
    }
    return output;
  }

  // Melee weapons
  List<MeleeWeapon> getMeleeWeapons() {
    return items
        .where((i) => i.category != null && i.category == "MELEE_WEAPONS")
        .cast<MeleeWeapon>()
        .toList();
  }

  Map<Skill, List<MeleeWeapon>> getMeleeWeaponsGrouped() {
    Map<Skill, List<MeleeWeapon>> output = {};
    for (MeleeWeapon meleeWeapon in getMeleeWeapons()) {
      var category = meleeWeapon.skill!;
      if (output.containsKey(category)) {
        output[category]!.add(meleeWeapon);
      } else {
        output[category] = [meleeWeapon];
      }
    }
    return output;
  }

  // Ranged weapons
  List<RangedWeapon> getRangedWeapons() {
    return items
        .where((i) => i.category != null && i.category == "RANGED_WEAPONS")
        .cast<RangedWeapon>()
        .toList();
  }

  Map<Skill, List<RangedWeapon>> getRangedWeaponsGrouped() {
    Map<Skill, List<RangedWeapon>> output = {};
    for (RangedWeapon weapon in getRangedWeapons()) {
      var category = weapon.skill!;
      if (output.containsKey(category)) {
        output[category]!.add(weapon);
      } else {
        output[category] = [weapon];
      }
    }
    return output;
  }

  // Armour
  List<Armour> getArmour() {
    return items
        .where((i) => i.category != null && i.category == "ARMOUR")
        .cast<Armour>()
        .toList();
  }

  // Items
  Map<String, Map<Item, int>> getCommonItemsGrouped() {
    Map<String, Map<Item, int>> output = {};
    for (Item item in items) {
      String category = item.category ?? "NONE";
      if (output.containsKey(category)) {
        output[category]![item] = item.count;
      } else {
        output[category] = {item: item.count};
      }
    }
    return output;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Character &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          race == other.race &&
          profession == other.profession &&
          mapEquals(attributes, other.attributes) &&
          mapEquals(skills, other.skills) &&
          mapEquals(talents, other.talents) &&
          listEquals(items, other.items) &&
          initiative == other.initiative;

  @override
  int get hashCode =>
      name.hashCode ^
      race.hashCode ^
      profession.hashCode ^
      attributes.hashCode ^
      skills.hashCode ^
      talents.hashCode ^
      items.hashCode ^
      initiative.hashCode;

  @override
  String toString() {
    return "Character (name=$name, race=$race, profession=$profession)";
  }
}
