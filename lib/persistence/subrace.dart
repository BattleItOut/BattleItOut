import 'dart:async';

import 'package:battle_it_out/persistence/race.dart';
import 'package:battle_it_out/persistence/skill/skill.dart';
import 'package:battle_it_out/persistence/skill/skill_group.dart';
import 'package:battle_it_out/persistence/talent/talent.dart';
import 'package:battle_it_out/persistence/talent/talent_group.dart';
import 'package:battle_it_out/utils/db_object.dart';
import 'package:battle_it_out/utils/factory.dart';

class SubracePartial extends DBObject {
  String? name;
  String? source;
  int? randomTalents;
  Race? race;
  bool? defaultSubrace;

  SubracePartial({super.id, this.name, this.source, this.randomTalents, this.race, this.defaultSubrace});

  Subrace toSubrace() {
    return Subrace(
        id: id,
        name: name!,
        source: source!,
        randomTalents: randomTalents!,
        race: race!,
        defaultSubrace: defaultSubrace!);
  }

  SubracePartial.from(Subrace? subrace)
      : this(
            id: subrace?.id,
            name: subrace?.name,
            source: subrace?.source,
            randomTalents: subrace?.randomTalents,
            race: subrace?.race,
            defaultSubrace: subrace?.defaultSubrace);

  @override
  List<Object?> get props => super.props..addAll([name, source, randomTalents, race, defaultSubrace]);

  bool compareTo(Subrace? subrace) {
    try {
      return toSubrace() == subrace;
    } on TypeError catch (_) {
      return false;
    }
  }
}

class Subrace extends DBObject {
  String name;
  String source;
  int randomTalents;
  Race race;
  bool defaultSubrace;

  List<Skill> linkedSkills = [];
  List<SkillGroup> linkedGroupSkills = [];
  List<Talent> linkedTalents = [];
  List<TalentGroup> linkedGroupTalents = [];

  Subrace(
      {super.id,
      required this.name,
      required this.race,
      this.source = "Custom",
      this.randomTalents = 0,
      this.defaultSubrace = true});

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => super.props
    ..addAll([
      name,
      source,
      randomTalents,
      race,
      defaultSubrace,
      linkedSkills,
      linkedGroupSkills,
      linkedTalents,
      linkedGroupTalents
    ]);
}

class SubraceFactory extends Factory<Subrace> {
  @override
  get tableName => 'subraces';

  @override
  Map<String, dynamic> get defaultValues => {"RANDOM_TALENTS": 0, "SRC": "Custom", "DEF": 1};

  Future<List<Subrace>> getSubracesFromRace(int raceId) async {
    return await getAll(where: "RACE_ID = $raceId");
  }

  Future<Race> getRace(Map<String, dynamic> map) async {
    if (map["RACE_ID"] != null) {
      return RaceFactory().get(map["RACE_ID"]);
    } else if (map["RACE"] != null) {
      return RaceFactory().create(map["RACE"]);
    } else {
      return RaceFactory().create(map);
    }
  }

  @override
  Future<Subrace> fromMap(Map<String, dynamic> map) async {
    Subrace subrace = Subrace(
        id: map["ID"] ?? await getNextId(),
        race: await getRace(map),
        name: map["NAME"],
        randomTalents: map["RANDOM_TALENTS"],
        source: map["SRC"],
        defaultSubrace: map["DEF"] == 1);
    subrace.linkedSkills = await SkillFactory().getLinkedToRace(subrace.id!);
    subrace.linkedGroupSkills = await SkillFactory().getGroupsLinkedToSubrace(subrace.id!);
    subrace.linkedTalents = await TalentFactory().getLinkedToSubrace(subrace.id!);
    subrace.linkedGroupTalents = await TalentFactory().getGroupsLinkedToSubrace(subrace.id!);
    return subrace;
  }

  @override
  Future<Subrace> fromDatabase(Map<String, dynamic> map) async {
    Subrace subrace = Subrace(
        id: map["ID"],
        race: await RaceFactory().get(map["RACE_ID"]),
        name: map["NAME"],
        randomTalents: map["RANDOM_TALENTS"],
        source: map["SRC"],
        defaultSubrace: map["DEF"] == 1);
    subrace.linkedSkills = await SkillFactory().getLinkedToRace(map["ID"]);
    subrace.linkedGroupSkills = await SkillFactory().getGroupsLinkedToSubrace(map["ID"]);
    subrace.linkedTalents = await TalentFactory().getLinkedToSubrace(map["ID"]);
    subrace.linkedGroupTalents = await TalentFactory().getGroupsLinkedToSubrace(map["ID"]);
    return subrace;
  }

  @override
  Future<Map<String, dynamic>> toDatabase(Subrace object, {optimised = true, database = false}) async {
    return {
      "ID": object.id,
      "RACE_ID": object.race.id,
      "NAME": object.name,
      "RANDOM_TALENTS": object.randomTalents,
      "SRC": object.source,
      "DEF": object.defaultSubrace ? 1 : 0
    };
  }

  @override
  Future<Map<String, dynamic>> toMap(Subrace object, {optimised = true, database = false}) async {
    Map<String, dynamic> map = {
      "ID": object.id,
      "RACE_ID": object.race.id,
      "NAME": object.name,
      "RANDOM_TALENTS": object.randomTalents,
      "SRC": object.source,
      "DEF": object.defaultSubrace ? 1 : 0
    };
    if (optimised) {
      map = await optimise(map);
    }
    return map;
  }
}
