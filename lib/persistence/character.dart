import 'package:battle_it_out/persistence/ancestry.dart';
import 'package:battle_it_out/persistence/attribute.dart';
import 'package:battle_it_out/persistence/item/armour.dart';
import 'package:battle_it_out/persistence/item/item.dart';
import 'package:battle_it_out/persistence/item/melee_weapon.dart';
import 'package:battle_it_out/persistence/item/ranged_weapon.dart';
import 'package:battle_it_out/persistence/profession/profession.dart';
import 'package:battle_it_out/persistence/size.dart';
import 'package:battle_it_out/persistence/skill/skill.dart';
import 'package:battle_it_out/persistence/skill/skill_base.dart';
import 'package:battle_it_out/persistence/talent/talent.dart';
import 'package:battle_it_out/persistence/talent/talent_base.dart';
import 'package:battle_it_out/persistence/trait.dart';
import 'package:battle_it_out/utils/db_object.dart';
import 'package:flutter/foundation.dart';

class Character extends DBObject {
  String name;
  String? description;
  Size? size;
  Ancestry? ancestry;
  Profession? profession;
  List<Attribute> attributes = [];
  List<Skill> skills = [];
  List<Talent> talents = [];
  List<Trait> traits = [];
  List<Item> items = [];
  List<Armour> armour = [];
  List<MeleeWeapon> meleeWeapons = [];
  List<RangedWeapon> rangedWeapons = [];

  // Temporary
  int? initiative;

  Character(
      {super.id,
      required this.name,
      this.size,
      this.ancestry,
      this.profession,
      this.description,
      this.initiative,
      List<Attribute> attributes = const [],
      List<Skill> skills = const [],
      List<Talent> talents = const [],
      List<Trait> traits = const [],
      List<Item> items = const [],
      List<MeleeWeapon> meleeWeapons = const []}) {
    this.items.addAll(items);
    this.attributes.addAll(attributes);
    this.skills.addAll(skills);
    this.talents.addAll(talents);
    this.traits.addAll(traits);
    this.meleeWeapons.addAll(meleeWeapons);
  }

  Size? getSize() {
    return ancestry?.race.size ?? size;
  }

  // List getters
  Map<BaseSkill, List<Skill>> getBasicSkillsGrouped() {
    Map<BaseSkill, List<Skill>> output = {};
    for (var skill in skills.where((skill) => !skill.isAdvanced())) {
      var category = skill.baseSkill;
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
    for (var skill in skills.where((skill) => skill.isAdvanced())) {
      var category = skill.baseSkill;
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
    for (var talent in talents) {
      var category = talent.baseTalent;
      if (output.containsKey(category)) {
        output[category]!.add(talent);
      } else {
        output[category] = [talent];
      }
    }
    return output;
  }

  Map<Skill, List<MeleeWeapon>> getMeleeWeaponsGrouped() {
    Map<Skill, List<MeleeWeapon>> output = {};
    for (MeleeWeapon meleeWeapon in meleeWeapons) {
      var category = meleeWeapon.skill!;
      if (output.containsKey(category)) {
        output[category]!.add(meleeWeapon);
      } else {
        output[category] = [meleeWeapon];
      }
    }
    return output;
  }

  Map<Skill, List<RangedWeapon>> getRangedWeaponsGrouped() {
    Map<Skill, List<RangedWeapon>> output = {};
    for (RangedWeapon weapon in rangedWeapons) {
      var category = weapon.skill!;
      if (output.containsKey(category)) {
        output[category]!.add(weapon);
      } else {
        output[category] = [weapon];
      }
    }
    return output;
  }

  // Items
  Map<String, Map<Item, int>> getCommonItemsGrouped() {
    Map<String, Map<Item, int>> output = {};
    for (Item item in items) {
      String category = item.category ?? "NONE";
      if (output.containsKey(category)) {
        output[category]![item] = item.amount;
      } else {
        output[category] = {item: item.amount};
      }
    }
    return output;
  }

  static Character from(Character character) {
    return Character(
        name: character.name,
        ancestry: character.ancestry,
        profession: character.profession,
        attributes: character.attributes.toList(),
        skills: character.skills,
        talents: character.talents,
        traits: character.traits,
        items: character.items,
        initiative: character.initiative);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Character &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          ancestry == other.ancestry &&
          profession == other.profession &&
          listEquals(attributes, other.attributes) &&
          listEquals(skills, other.skills) &&
          listEquals(talents, other.talents) &&
          listEquals(items, other.items);

  @override
  int get hashCode =>
      name.hashCode ^
      ancestry.hashCode ^
      profession.hashCode ^
      attributes.hashCode ^
      skills.hashCode ^
      talents.hashCode ^
      items.hashCode;

  @override
  String toString() {
    return "Character (name=$name, ancestry=$ancestry, profession=$profession)";
  }
}
