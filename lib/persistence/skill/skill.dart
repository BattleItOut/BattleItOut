import 'package:battle_it_out/persistence/attribute.dart';
import 'package:battle_it_out/persistence/skill/skill_base.dart';
import 'package:battle_it_out/persistence/skill/skill_group.dart';
import 'package:battle_it_out/utils/db_object.dart';
import 'package:battle_it_out/utils/factory.dart';

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
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Skill &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          specialisation == other.specialisation &&
          baseSkill == other.baseSkill;

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ specialisation.hashCode ^ baseSkill.hashCode;

  @override
  String toString() {
    return 'Skill{id: $id, name: $name, specialisation: $specialisation, baseSkill: $baseSkill, advances: $advances, earning: $earning, canAdvance: $canAdvance}';
  }
}

class SkillFactory extends Factory<Skill> {
  List<Attribute>? attributes;

  SkillFactory([this.attributes]);

  @override
  get tableName => 'skills';

  Future<List<Skill>> getSkills({bool? advanced}) async {
    List<Skill> skills = await getAll();
    if (advanced != null) {
      skills = List.of(skills.where((skill) => skill.baseSkill.advanced == advanced));
    }
    return skills;
  }

  Future<List<Skill>> getLinkedToRace(int? subraceId) async {
    final List<Map<String, dynamic>> map = await database.rawQuery(
        "SELECT * FROM SUBRACE_SKILLS RS JOIN SKILLS S ON (S.ID = RS.SKILL_ID) WHERE SUBRACE_ID = ?", [subraceId]);

    return [for (Map<String, dynamic> entry in map) await fromDatabase(entry)];
  }

  Future<List<SkillGroup>> getGroupsLinkedToSubrace(int? subraceId) async {
    final List<Map<String, dynamic>> map = await database.rawQuery(
        "SELECT * FROM SUBRACE_SKILLS SS JOIN SKILLS_BASE SB ON (SS.BASE_SKILL_ID = SB.ID) WHERE SUBRACE_ID = ?",
        [subraceId]);

    return [
      for (Map<String, dynamic> entry in map)
        SkillGroup(
          name: "${entry["NAME"]}_ANY",
          skills: await getAll(where: "ID = ?", whereArgs: [entry["BASE_SKILL_ID"]]),
        )
    ];
  }

  Future<List<Skill>> getLinkedToProfession(int? professionId) async {
    final List<Map<String, dynamic>> map = await database.rawQuery(
        "SELECT * FROM PROFESSION_SKILLS PS JOIN SKILLS S ON (PS.SKILL_ID = S.ID) WHERE PROFESSION_ID = ?",
        [professionId]);

    return [for (Map<String, dynamic> entry in map) await fromDatabase(entry)];
  }

  Future<List<SkillGroup>> getGroupsLinkedToProfession(int? professionId) async {
    List<Map<String, dynamic>> baseSkillsMap = await database.rawQuery(
        "SELECT * FROM PROFESSION_SKILLS PS JOIN SKILLS_BASE SB ON (PS.BASE_SKILL_ID = SB.ID) WHERE PROFESSION_ID = ?",
        [professionId]);

    List<SkillGroup> skillGroups = [
      for (Map<String, dynamic> entry in baseSkillsMap)
        SkillGroup(
          name: "${entry["NAME"]}_ANY",
          skills: await getAll(where: "ID = ?", whereArgs: [entry["BASE_SKILL_ID"]]),
        )
    ];

    List<Map<String, dynamic>> groupSkillsMap = await database.rawQuery(
        "SELECT * FROM PROFESSION_SKILLS PS JOIN SKILL_GROUPS SB ON (PS.SKILL_GROUP_ID = SB.ID) WHERE PROFESSION_ID = ?",
        [professionId]);
    for (Map<String, dynamic> entry in groupSkillsMap) {
      List<Map<String, dynamic>> skillsMap = await database.rawQuery(
          "SELECT * FROM SKILL_GROUPS_HIERARCHY SGH JOIN SKILLS S on S.ID = SGH.CHILD_ID WHERE PARENT_ID = ?",
          [entry["SKILL_GROUP_ID"] as int]);
      skillGroups.add(
        SkillGroup(
          name: entry["NAME"],
          skills: [for (Map<String, dynamic> skillEntry in skillsMap) await fromDatabase(skillEntry)],
        ),
      );
    }
    return skillGroups;
  }

  @override
  Future<Skill> fromDatabase(Map<String, dynamic> map) async {
    return Skill(
        id: map["ID"],
        name: map["NAME"],
        specialisation: map["SPECIALISATION"],
        baseSkill: await BaseSkillFactory(attributes).get(map["BASE_SKILL_ID"]),
        advances: map["ADVANCES"] ?? 0,
        earning: map["EARNING"] == 1,
        canAdvance: map["CAN_ADVANCE"] == 1);
  }

  @override
  Future<Map<String, dynamic>> toDatabase(Skill object) async {
    return {
      "ID": object.id,
      "NAME": object.name,
      "SPECIALISATION": object.specialisation,
      "BASE_SKILL_ID": object.baseSkill.id
    };
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
    if (object.baseSkill != await BaseSkillFactory().get(object.baseSkill.id!)) {
      map["BASE_SKILL"] = BaseSkillFactory().toDatabase(object.baseSkill);
    }
    return map;
  }
}
