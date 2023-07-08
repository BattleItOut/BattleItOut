import 'package:battle_it_out/persistence/entities/attribute.dart';
import 'package:battle_it_out/persistence/entities/skill.dart';

class Talent {
  int id;
  String name;
  String? specialisation;
  BaseTalent? baseTalent;
  int? baseTalentID;
  List<TalentTest> tests = [];

  int currentLvl = 0;
  bool advancable = false;

  Talent(
      {required this.id,
      required this.name,
      this.specialisation,
      this.baseTalent,
      List<TalentTest> tests = const [],
      this.currentLvl = 0,
      this.advancable = false}) {
    this.tests.addAll(tests);
  }

  bool isSpecialised() {
    return specialisation != null;
  }

  int? getMaxLvl() {
    return baseTalent!.getMaxLvl();
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Talent &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          specialisation == other.specialisation &&
          baseTalentID == other.baseTalentID &&
          currentLvl == other.currentLvl &&
          advancable == other.advancable;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      specialisation.hashCode ^
      baseTalentID.hashCode ^
      currentLvl.hashCode ^
      advancable.hashCode;

  @override
  String toString() {
    return "Talent (id=$id, name=$name)";
  }
}

class BaseTalent {
  int id;
  String name;
  String description;
  String source;
  Attribute? attribute;
  int? attributeID;
  int? constLvl;
  bool grouped;

  BaseTalent(
      {required this.id,
      required this.name,
      required this.description,
      required this.source,
      this.attribute,
      this.constLvl,
      required this.grouped});

  int? getMaxLvl() {
    if (attribute != null) {
      return attribute!.getTotalValue() ~/ 10;
    }
    if (constLvl != null) {
      return constLvl;
    }
    return null;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BaseTalent &&
          id == other.id &&
          name == other.name &&
          description == other.description &&
          source == other.source &&
          grouped == other.grouped &&
          attributeID == other.attributeID &&
          constLvl == other.constLvl;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      description.hashCode ^
      constLvl.hashCode ^
      source.hashCode ^
      grouped.hashCode ^
      attributeID.hashCode;
}

class TalentTest {
  int? id;
  Talent? talent;
  String? comment;

  BaseSkill? baseSkill;
  Skill? skill;
  Attribute? attribute;

  TalentTest(
      {required this.id,
      required this.talent,
      this.comment,
      this.baseSkill,
      this.skill,
      this.attribute});

  @override
  String toString() {
    return "Test (id=$id, name=$comment, attribute=$attribute, baseSkill=$baseSkill, skill=$skill)";
  }
}
