import 'package:battle_it_out/persistence/entities/character/simple_character.dart';
import 'package:flutter/foundation.dart';

class Character extends SimpleCharacter {
  Character(
      {required super.name,
      super.description,
      required super.subrace,
      required super.profession,
      super.initiative,
      super.attributes,
      super.skills,
      super.talents,
      super.traits,
      super.items});

  static Character from(Character character) {
    var newInstance = Character(
        name: character.name,
        subrace: character.subrace,
        profession: character.profession,
        attributes: character.attributes);
    newInstance.skills = character.skills;
    newInstance.talents = character.talents;
    newInstance.initiative = character.initiative;
    return newInstance;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Character &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          subrace == other.subrace &&
          profession == other.profession &&
          listEquals(attributes, other.attributes) &&
          listEquals(skills, other.skills) &&
          listEquals(talents, other.talents) &&
          listEquals(items, other.items) &&
          initiative == other.initiative;

  @override
  int get hashCode =>
      name.hashCode ^
      subrace.hashCode ^
      profession.hashCode ^
      attributes.hashCode ^
      skills.hashCode ^
      talents.hashCode ^
      items.hashCode ^
      initiative.hashCode;

  @override
  String toString() {
    return "Character (name=$name, subrace=$subrace, profession=$profession)";
  }
}
