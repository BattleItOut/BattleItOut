import 'package:battle_it_out/persistence/attribute.dart';
import 'package:battle_it_out/persistence/serializer.dart';
import 'package:battle_it_out/persistence/skill/skill_base.dart';
import 'package:battle_it_out/persistence/skill/skill_group.dart';
import 'package:battle_it_out/utils/database_provider.dart';
import 'package:sqflite/sqflite.dart';

class Skill {
  int id;
  String name;
  String? specialisation;
  BaseSkill baseSkill;

  int advances;
  bool earning;
  bool canAdvance;

  Skill._(
      {required this.id,
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

  Future<List<Skill>> getLinkedToRace(int subraceId) async {
    Database? database = await DatabaseProvider.instance.getDatabase();

    final List<Map<String, dynamic>> map = await database.rawQuery(
        "SELECT * FROM SUBRACE_SKILLS RS JOIN SKILLS S ON (S.ID = RS.SKILL_ID) WHERE SUBRACE_ID = ?", [subraceId]);

    return [for (Map<String, dynamic> entry in map) await create(entry)];
  }

  Future<List<SkillGroup>> getGroupsLinkedToSubrace(int subraceId) async {
    Database? database = await DatabaseProvider.instance.getDatabase();

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

  @override
  Future<Skill> fromMap(Map<String, dynamic> map) async {
    return Skill._(
        id: map["ID"],
        name: map["NAME"],
        specialisation: map["SPECIALISATION"],
        baseSkill: await BaseSkillFactory(attributes).get(map["BASE_SKILL_ID"]),
        advances: map["ADVANCES"] ?? 0,
        earning: map["EARNING"] ?? false,
        canAdvance: map["CAN_ADVANCE"] ?? false);
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
    if ((object.baseSkill != await BaseSkillFactory().get(object.baseSkill.id))) {
      map["BASE_SKILL"] = BaseSkillFactory().toMap(object.baseSkill);
    }
    return map;
  }
}
