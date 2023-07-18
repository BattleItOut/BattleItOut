import 'package:battle_it_out/persistence/attribute.dart';
import 'package:battle_it_out/persistence/serializer.dart';
import 'package:battle_it_out/persistence/skill/skill_base.dart';

class Skill {
  int id;
  String name;
  String? specialisation;
  int? baseSkillID;
  BaseSkill? baseSkill;

  int advances;
  bool earning;
  bool canAdvance;

  Skill._(
      {required this.id,
      required this.name,
      required this.specialisation,
      this.advances = 0,
      this.earning = false,
      this.canAdvance = false,
      this.baseSkill});

  bool isGroup() {
    return baseSkill == null;
  }

  bool isAdvanced() {
    return baseSkill!.advanced;
  }

  bool isSpecialised() {
    return specialisation != null;
  }

  bool isImportant() {
    return advances != 0 || canAdvance || earning;
  }

  Attribute? getAttribute() {
    return baseSkill!.getAttribute();
  }

  int getTotalValue() {
    return baseSkill!.getTotalValue() + advances;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Skill &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          specialisation == other.specialisation &&
          baseSkillID == other.baseSkillID;

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ specialisation.hashCode ^ baseSkillID.hashCode;

  @override
  String toString() {
    return "Skill (id=$id, name=$name, advances=$advances)";
  }
}

class SkillFactory extends Factory<Skill> {
  List<Attribute>? attributes;

  SkillFactory([this.attributes]);

  @override
  get tableName => 'skills';

  getSkills({bool? advanced}) async {
    List<Skill> skills = await getAll(where: "BASE_SKILL_ID IS NOT NULL");
    if (advanced != null) {
      skills = List.of(skills.where((skill) => skill.baseSkill!.advanced == advanced));
    }
    return skills;
  }

  @override
  Future<Skill> fromMap(Map<String, dynamic> map) async {
    Skill skill = Skill._(
        id: map["ID"],
        name: map["NAME"],
        specialisation: map["SPECIALISATION"],
        advances: map["ADVANCES"] ?? 0,
        earning: map["EARNING"] ?? false,
        canAdvance: map["CAN_ADVANCE"] ?? false);
    if (map["BASE_SKILL_ID"] != null) {
      skill.baseSkillID = map["BASE_SKILL_ID"];
      skill.baseSkill = await BaseSkillFactory(attributes).get(map["BASE_SKILL_ID"]);
    }
    return skill;
  }

  @override
  Future<Map<String, dynamic>> toMap(Skill object, {optimised = true, database = false}) async {
    Map<String, dynamic> map = {
      "ID": object.id,
      "NAME": object.name,
      "SPECIALISATION": object.specialisation,
      "ADVANCES": object.advances,
      "EARNING": object.earning,
      "CAN_ADVANCE": object.canAdvance
    };
    if (optimised) {
      map = await optimise(map);
    }
    if (object.baseSkill != null &&
        (object.baseSkill!.id == null || object.baseSkill != await BaseSkillFactory().get(object.baseSkill!.id!))) {
      map["BASE_SKILL"] = BaseSkillFactory().toMap(object.baseSkill!);
    }
    return map;
  }
}
