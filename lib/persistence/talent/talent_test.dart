import 'package:battle_it_out/persistence/attribute.dart';
import 'package:battle_it_out/persistence/skill/skill.dart';
import 'package:battle_it_out/persistence/skill/skill_base.dart';
import 'package:battle_it_out/persistence/talent/talent.dart';
import 'package:battle_it_out/utils/db_object.dart';

class TalentTest extends DBObject {
  Talent? talent;
  String? comment;

  BaseSkill? baseSkill;
  Skill? skill;
  Attribute? attribute;

  TalentTest({super.id, required this.talent, this.comment, this.baseSkill, this.skill, this.attribute});

  @override
  String toString() {
    return "Test (id=$id, name=$comment, attribute=$attribute, baseSkill=$baseSkill, skill=$skill)";
  }
}
