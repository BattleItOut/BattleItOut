import 'package:battle_it_out/persistence/profession/profession_career.dart';
import 'package:battle_it_out/persistence/skill/skill.dart';
import 'package:battle_it_out/persistence/skill/skill_group.dart';
import 'package:battle_it_out/persistence/talent/talent.dart';
import 'package:battle_it_out/persistence/talent/talent_group.dart';
import 'package:battle_it_out/utils/db_object.dart';

class Profession extends DBObject {
  String name;
  String source;
  int level;
  ProfessionCareer career;

  List<Skill> linkedSkills = [];
  List<SkillGroup> linkedGroupSkills = [];
  List<Talent> linkedTalents = [];
  List<TalentGroup> linkedGroupTalents = [];

  Profession({super.id, required this.name, required this.career, this.level = 1, this.source = "Custom"});

  @override
  String toString() {
    return "Profession (id=$id, name=$name, lvl=$level)";
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Profession &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          source == other.source &&
          level == other.level &&
          career == other.career;

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ source.hashCode ^ level.hashCode ^ career.hashCode;
}
