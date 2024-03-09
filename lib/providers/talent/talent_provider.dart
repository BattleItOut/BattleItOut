import 'package:battle_it_out/persistence/talent/talent.dart';
import 'package:battle_it_out/persistence/talent/talent_group.dart';
import 'package:battle_it_out/providers/talent/base_talent_provider.dart';
import 'package:battle_it_out/providers/talent/talent_test_provider.dart';
import 'package:battle_it_out/utils/factory.dart';
import 'package:get_it/get_it.dart';

class TalentRepository extends Repository<Talent> {
  @override
  get tableName => 'talents';

  @override
  Future<void> init() async {
    if (ready) return;
    await GetIt.instance.get<BaseTalentRepository>().init();
    await super.init();
  }

  Future<List<Talent>> getLinkedToAncestry(int? ancestryId) async {
    final List<Map<String, dynamic>> map = await database.rawQuery(
        "SELECT * FROM SUBRACE_TALENTS ST JOIN TALENTS T ON (T.ID = ST.TALENT_ID) WHERE SUBRACE_ID = ?", [ancestryId]);

    return [for (Map<String, dynamic> entry in map) await fromDatabase(entry)];
  }

  Future<List<TalentGroup>> getGroupsLinkedToAncestry(int? ancestryId) async {
    List<Map<String, dynamic>> baseSkillsMap = await database.rawQuery(
        "SELECT * FROM SUBRACE_TALENTS ST JOIN TALENTS_BASE SB ON (ST.BASE_TALENT_ID = SB.ID) WHERE SUBRACE_ID = ?",
        [ancestryId]);

    List<TalentGroup> talentGroups = [
      for (Map<String, dynamic> entry in baseSkillsMap)
        TalentGroup(
          name: "${entry["NAME"]}_ANY",
          randomTalent: entry["RANDOM_TALENT"] == 1,
          talents: await getMapAll(where: "ID = ?", whereArgs: [entry["BASE_TALENT_ID"]]),
        )
    ];

    List<Map<String, dynamic>> groupTalentsMap = await database.rawQuery(
        "SELECT * FROM SUBRACE_TALENTS ST JOIN TALENT_GROUPS TG ON (ST.TALENT_GROUP_ID = TG.ID) WHERE SUBRACE_ID = ?",
        [ancestryId]);
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

  Future<List<Talent>> getLinkedToProfession(int? professionId) async {
    final List<Map<String, dynamic>> map = await database.rawQuery(
        "SELECT * FROM PROFESSION_TALENTS ST JOIN TALENTS T ON (T.ID = ST.TALENT_ID) WHERE PROFESSION_ID = ?",
        [professionId]);

    return [for (Map<String, dynamic> entry in map) await fromDatabase(entry)];
  }

  @override
  Future<Talent> fromDatabase(Map<String, dynamic> map) async {
    Talent talent = Talent(
        id: map['ID'],
        name: map['NAME'],
        specialisation: map["SPECIALISATION"],
        baseTalent: (await GetIt.instance.get<BaseTalentRepository>().get(map["BASE_TALENT_ID"]))!,
        currentLvl: map["LVL"] ?? 0,
        canAdvance: map["CAN_ADVANCE"] == 1);

    // Tests
    talent.tests = await GetIt.instance.get<TalentTestRepository>().getAllByTalent(map["ID"]);
    if (map["TESTS"] != null) {
      talent.tests
          .addAll([for (map in map["TESTS"]) await GetIt.instance.get<TalentTestRepository>().fromDatabase(map)]);
    }
    return talent;
  }

  @override
  Future<Map<String, dynamic>> toDatabase(Talent object) async {
    return {
      "ID": object.id,
      "NAME": object.name,
      "SPECIALISATION": object.specialisation,
      "BASE_TALENT_ID": object.baseTalent.id
    };
  }

  @override
  Future<Map<String, dynamic>> toMap(Talent object, {optimised = true, database = false}) async {
    Map<String, dynamic> map = {
      "ID": object.id,
      "NAME": object.name,
      "SPECIALISATION": object.specialisation,
      "LVL": object.currentLvl,
      "CAN_ADVANCE": object.canAdvance ? 1 : 0
    };
    if (optimised) {
      map = await optimise(map);
    }
    if ((object.baseTalent.id == null ||
        object.baseTalent != await GetIt.instance.get<BaseTalentRepository>().get(object.baseTalent.id!))) {
      map["BASE_TALENT"] = GetIt.instance.get<BaseTalentRepository>().toDatabase(object.baseTalent);
    }
    return map;
  }
}
