import 'package:battle_it_out/persistence/attribute.dart';
import 'package:battle_it_out/persistence/serializer.dart';
import 'package:battle_it_out/persistence/skill/skill.dart';
import 'package:battle_it_out/persistence/talent/talent_base.dart';
import 'package:battle_it_out/persistence/talent/talent_test.dart';
import 'package:battle_it_out/utils/database_provider.dart';
import 'package:sqflite/sqflite.dart';

class Talent {
  int id;
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

  getAllTalents() async {
    return await getAll(where: "BASE_TALENT_ID IS NOT NULL");
  }

  Future<List<Talent>> getLinkedToRace(int subraceId) async {
    Database? database = await DatabaseProvider.instance.getDatabase();

    final List<Map<String, dynamic>> map = await database.rawQuery(
        "SELECT * FROM SUBRACE_TALENTS ST JOIN TALENTS T ON (T.ID = ST.TALENT_ID) WHERE RACE_ID = ?", [subraceId]);

    return [for (Map<String, dynamic> entry in map) await create(entry)];
  }

  Future<List<Talent>> getLinkedToProfession(int professionId) async {
    Database? database = await DatabaseProvider.instance.getDatabase();

    final List<Map<String, dynamic>> map = await database.rawQuery(
        "SELECT * FROM PROF_TALENTS ST JOIN TALENTS T ON (T.ID = ST.TALENT_ID) WHERE PROFESSION_ID = ?",
        [professionId]);

    return [for (Map<String, dynamic> entry in map) await create(entry)];
  }

  @override
  Future<Talent> fromMap(Map<String, dynamic> map) async {
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
      talent.tests.addAll([for (map in map["TESTS"]) await TalentTestFactory(talent).create(map)]);
    }
    return talent;
  }

  @override
  Future<Map<String, dynamic>> toMap(Talent object, {optimised = true, database = false}) async {
    Map<String, dynamic> map = {
      "ID": object.id,
      "NAME": object.name,
      "SPECIALISATION": object.specialisation,
      "LVL": object.currentLvl,
      "CAN_ADVANCE": object.canAdvance
    };
    if (optimised) {
      map = await optimise(map);
    }
    if (object.baseTalent != null &&
        object.baseTalent != await BaseTalentFactory(attributes).get(object.baseTalent!.id)) {
      map["BASE_TALENT"] = BaseTalentFactory().toMap(object.baseTalent!);
    }
    return map;
  }
}
