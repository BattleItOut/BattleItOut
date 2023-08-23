import 'package:battle_it_out/persistence/attribute.dart';
import 'package:battle_it_out/persistence/skill/skill.dart';
import 'package:battle_it_out/persistence/talent/talent_base.dart';
import 'package:battle_it_out/persistence/talent/talent_group.dart';
import 'package:battle_it_out/persistence/talent/talent_test.dart';
import 'package:battle_it_out/utils/database_provider.dart';
import 'package:battle_it_out/utils/db_object.dart';
import 'package:battle_it_out/utils/serializer.dart';
import 'package:sqflite/sqflite.dart';

class Talent extends DBObject {
  int? id;
  String name;
  String? specialisation;
  BaseTalent? baseTalent;
  int? baseTalentID;
  List<TalentTest> tests = [];

  int currentLvl = 0;
  bool canAdvance = false;

  Talent._(
      {required this.id,
      required this.name,
      this.specialisation,
      List<TalentTest> tests = const [],
      this.currentLvl = 0,
      this.canAdvance = false}) {
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
          canAdvance == other.canAdvance;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      specialisation.hashCode ^
      baseTalentID.hashCode ^
      currentLvl.hashCode ^
      canAdvance.hashCode;

  @override
  String toString() {
    return "Talent (id=$id, name=$name)";
  }
}

class TalentFactory extends Factory<Talent> {
  List<Attribute>? attributes;
  List<Skill>? skills;

  TalentFactory([this.attributes, this.skills]);

  @override
  get tableName => 'talents';

  Future<List<Talent>> getLinkedToSubrace(int subraceId) async {
    Database? database = await DatabaseProvider.instance.getDatabase();

    final List<Map<String, dynamic>> map = await database.rawQuery(
        "SELECT * FROM SUBRACE_TALENTS ST JOIN TALENTS T ON (T.ID = ST.TALENT_ID) WHERE SUBRACE_ID = ?", [subraceId]);

    return [for (Map<String, dynamic> entry in map) await fromDatabase(entry)];
  }

  Future<List<TalentGroup>> getGroupsLinkedToSubrace(int subraceId) async {
    Database? database = await DatabaseProvider.instance.getDatabase();

    List<Map<String, dynamic>> baseSkillsMap = await database.rawQuery(
        "SELECT * FROM SUBRACE_TALENTS ST JOIN TALENTS_BASE SB ON (ST.BASE_TALENT_ID = SB.ID) WHERE SUBRACE_ID = ?",
        [subraceId]);

    List<TalentGroup> talentGroups = [
      for (Map<String, dynamic> entry in baseSkillsMap)
        TalentGroup(
          name: "${entry["NAME"]}_ANY",
          randomTalent: entry["RANDOM_TALENT"] == 1,
          talents: await getAll(where: "ID = ?", whereArgs: [entry["BASE_TALENT_ID"]]),
        )
    ];

    List<Map<String, dynamic>> groupTalentsMap = await database.rawQuery(
        "SELECT * FROM SUBRACE_TALENTS ST JOIN TALENT_GROUPS TG ON (ST.TALENT_GROUP_ID = TG.ID) WHERE SUBRACE_ID = ?",
        [subraceId]);
    for (Map<String, dynamic> entry in groupTalentsMap) {
      List<Map<String, dynamic>> talentsMap = await database.rawQuery(
          "SELECT * FROM TALENT_GROUPS_HIERARCHY TGH JOIN TALENTS T on T.ID = TGH.CHILD_ID WHERE PARENT_ID = ?",
          [entry["TALENT_GROUP_ID"] as int]);
      talentGroups.add(
        TalentGroup(
          name: entry["NAME"],
          randomTalent: entry["RANDOM_TALENT"] == 1,
          talents: [for (Map<String, dynamic> skillEntry in talentsMap) await fromDatabase(skillEntry)],
        ),
      );
    }
    return talentGroups;
  }

  Future<List<Talent>> getLinkedToProfession(int professionId) async {
    Database? database = await DatabaseProvider.instance.getDatabase();

    final List<Map<String, dynamic>> map = await database.rawQuery(
        "SELECT * FROM PROFESSION_TALENTS ST JOIN TALENTS T ON (T.ID = ST.TALENT_ID) WHERE PROFESSION_ID = ?",
        [professionId]);

    return [for (Map<String, dynamic> entry in map) await fromDatabase(entry)];
  }

  @override
  Future<Talent> fromDatabase(Map<String, dynamic> map) async {
    Talent talent = Talent._(
        id: map['ID'],
        name: map['NAME'],
        specialisation: map["SPECIALISATION"],
        currentLvl: map["LVL"] ?? 0,
        canAdvance: map["CAN_ADVANCE"] ?? false);

    // Base talent
    if (map["BASE_TALENT_ID"] != null) {
      talent.baseTalent = await BaseTalentFactory(attributes).get(map["BASE_TALENT_ID"]);
    }

    // Tests
    talent.tests = await TalentTestFactory(talent).getAllByTalent(map["ID"]);
    if (map["TESTS"] != null) {
      talent.tests.addAll([for (map in map["TESTS"]) await TalentTestFactory(talent).fromDatabase(map)]);
    }
    return talent;
  }

  @override
  Future<Map<String, dynamic>> toDatabase(Talent object) async {
    Map<String, dynamic> map = {
      "ID": object.id,
      "NAME": object.name,
      "SPECIALISATION": object.specialisation,
      "LVL": object.currentLvl,
      "CAN_ADVANCE": object.canAdvance
    };
    if (object.baseTalent != null &&
        object.baseTalent != await BaseTalentFactory(attributes).get(object.baseTalent!.id!)) {
      map["BASE_TALENT"] = BaseTalentFactory().toDatabase(object.baseTalent!);
    }
    return map;
  }

  // @override
  // Future<Map<String, dynamic>> toMap(Talent object, {optimised = true, database = false}) async {
  //   Map<String, dynamic> map = {
  //     "ID": object.id,
  //     "NAME": object.name,
  //     "SPECIALISATION": object.specialisation,
  //     "LVL": object.currentLvl,
  //     "CAN_ADVANCE": object.canAdvance
  //   };
  //   if (optimised) {
  //     map = await optimise(map);
  //   }
  //   if (object.baseTalent != null &&
  //       object.baseTalent != await BaseTalentFactory(attributes).get(object.baseTalent!.id)) {
  //     map["BASE_TALENT"] = BaseTalentFactory().toDatabase(object.baseTalent!);
  //   }
  //   return map;
  // }
}
