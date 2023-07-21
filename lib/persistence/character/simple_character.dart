import 'package:battle_it_out/persistence/attribute.dart';
import 'package:battle_it_out/persistence/item/armour.dart';
import 'package:battle_it_out/persistence/item/item.dart';
import 'package:battle_it_out/persistence/item/melee_weapon.dart';
import 'package:battle_it_out/persistence/item/ranged_weapon.dart';
import 'package:battle_it_out/persistence/profession/profession.dart';
import 'package:battle_it_out/persistence/skill/skill.dart';
import 'package:battle_it_out/persistence/skill/skill_base.dart';
import 'package:battle_it_out/persistence/subrace.dart';
import 'package:battle_it_out/persistence/talent/talent.dart';
import 'package:battle_it_out/persistence/talent/talent_base.dart';
import 'package:battle_it_out/persistence/trait.dart';

class SimpleCharacter {
  String name;
  String? description;
  Subrace? subrace;
  Profession? profession;
  List<Attribute> attributes = [];
  List<Skill> skills = [];
  List<Talent> talents = [];
  List<Trait> traits = [];
  List<Item> items = [];

  // Temporary
  int? initiative;

  SimpleCharacter(
      {required this.name,
      this.description,
      this.subrace,
      this.profession,
      this.initiative,
      List<Attribute> attributes = const [],
      List<Skill> skills = const [],
      List<Talent> talents = const [],
      List<Trait> traits = const [],
      List<Item> items = const []}) {
    this.items.addAll(items);
    this.attributes.addAll(attributes);
    this.skills.addAll(skills);
    this.talents.addAll(talents);
    this.traits.addAll(traits);
  }

  // List getters
  Map<BaseSkill, List<Skill>> getBasicSkillsGrouped() {
    Map<BaseSkill, List<Skill>> output = {};
    for (var skill in skills.where((skill) => !skill.isAdvanced())) {
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
    for (var skill in skills.where((skill) => skill.isAdvanced())) {
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
    for (var talent in talents) {
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
    return items.where((i) => i.category != null && i.category == "MELEE_WEAPONS").cast<MeleeWeapon>().toList();
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
    return items.where((i) => i.category != null && i.category == "RANGED_WEAPONS").cast<RangedWeapon>().toList();
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
    return items.where((i) => i.category != null && i.category == "ARMOUR").cast<Armour>().toList();
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

  static SimpleCharacter from(SimpleCharacter character) {
    return SimpleCharacter(
        name: character.name,
        subrace: character.subrace,
        profession: character.profession,
        attributes: character.attributes,
        skills: character.skills,
        talents: character.talents,
        traits: character.traits,
        items: character.items,
        initiative: character.initiative);
  }
}
