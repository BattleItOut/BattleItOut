import 'package:battle_it_out/persistence/entities/attribute.dart';
import 'package:battle_it_out/persistence/entities/skill.dart';
import 'package:uuid/uuid.dart';

class Talent {
  late String id;
  int? databaseId;
  String name;
  String? specialisation;
  BaseTalent? baseTalent;
  List<TalentTest> tests = [];

  int currentLvl = 0;
  bool canAdvance = false;

  Talent(
      {String? id,
      this.databaseId,
      required this.name,
      this.specialisation,
      this.baseTalent,
      this.currentLvl = 0,
      this.canAdvance = false,
      List<TalentTest> tests = const []}) {
    this.tests.addAll(tests);
    this.id = id ?? const Uuid().v4();
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
          databaseId == other.databaseId &&
          name == other.name &&
          specialisation == other.specialisation &&
          currentLvl == other.currentLvl &&
          canAdvance == other.canAdvance;

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ specialisation.hashCode ^ currentLvl.hashCode ^ canAdvance.hashCode;

  @override
  String toString() {
    return "Talent (id=$id, name=$name)";
  }
}

class BaseTalent {
  late String id;
  int? databaseId;
  String name;
  String description;
  String source;
  Attribute? attribute;
  int? attributeID;
  int? constLvl;
  bool grouped;

  BaseTalent(
      {String? id,
      this.databaseId,
      required this.name,
      required this.description,
      required this.source,
      this.attribute,
      this.constLvl,
      required this.grouped}) {
    this.id = id ?? const Uuid().v4();
  }

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
          databaseId == other.databaseId &&
          name == other.name &&
          description == other.description &&
          source == other.source &&
          grouped == other.grouped &&
          attributeID == other.attributeID &&
          constLvl == other.constLvl;

  @override
  int get hashCode =>
      databaseId.hashCode ^
      name.hashCode ^
      description.hashCode ^
      constLvl.hashCode ^
      source.hashCode ^
      grouped.hashCode ^
      attributeID.hashCode;
}

class TalentTest {
  late String id;
  int? databaseId;
  Talent? talent;
  String? comment;

  BaseSkill? baseSkill;
  Skill? skill;
  Attribute? attribute;

  TalentTest(
      {String? id, this.databaseId, required this.talent, this.comment, this.baseSkill, this.skill, this.attribute}) {
    this.id = id ?? const Uuid().v4();
  }

  @override
  String toString() {
    return "Test (id=$id, name=$comment, attribute=$attribute, baseSkill=$baseSkill, skill=$skill)";
  }
}
