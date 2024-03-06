import 'package:battle_it_out/persistence/attribute.dart';
import 'package:battle_it_out/persistence/skill/skill_base.dart';
import 'package:battle_it_out/utils/db_object.dart';

class Skill extends DBObject {
  String name;
  String? specialisation;
  BaseSkill baseSkill;

  int advances;
  bool earning;
  bool canAdvance;

  Skill(
      {super.id,
      required this.name,
      required this.baseSkill,
      this.specialisation,
      this.advances = 0,
      this.earning = false,
      this.canAdvance = false});

  bool isAdvanced() {
    return baseSkill.advanced;
  }

  bool isSpecialised() {
    return specialisation != null;
  }

  bool isImportant() {
    return advances != 0 || canAdvance || earning;
  }

  Attribute? getAttribute() {
    return baseSkill.getAttribute();
  }

  int getTotalValue() {
    return baseSkill.getTotalValue() + advances;
  }

  @override
  List<Object?> get props => super.props..addAll([name, specialisation, baseSkill]);
}
