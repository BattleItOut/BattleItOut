import 'dart:async';

import 'package:battle_it_out/persistence/race.dart';
import 'package:battle_it_out/persistence/skill/skill.dart';
import 'package:battle_it_out/persistence/skill/skill_group.dart';
import 'package:battle_it_out/persistence/talent/talent.dart';
import 'package:battle_it_out/persistence/talent/talent_group.dart';
import 'package:battle_it_out/utils/db_object.dart';
import 'package:battle_it_out/utils/factory.dart';

class AncestryPartial extends DBObject {
  String? name;
  String? source;
  int? randomTalents;
  Race? race;
  bool? defaultAncestry;

  AncestryPartial({super.id, this.name, this.source, this.randomTalents, this.race, this.defaultAncestry});

  Ancestry to() {
    return Ancestry(
        id: id,
        name: name!,
        source: source!,
        randomTalents: randomTalents!,
        race: race!,
        defaultAncestry: defaultAncestry!);
  }

  AncestryPartial.from(Ancestry? ancestry)
      : this(
            id: ancestry?.id,
            name: ancestry?.name,
            source: ancestry?.source,
            randomTalents: ancestry?.randomTalents,
            race: ancestry?.race,
            defaultAncestry: ancestry?.defaultAncestry);

  @override
  List<Object?> get props => super.props..addAll([name, source, randomTalents, race, defaultAncestry]);

  bool compareTo(Ancestry? ancestry) {
    try {
      return to() == ancestry;
    } on TypeError catch (_) {
      return false;
    }
  }
}

class Ancestry extends DBObject {
  String name;
  String source;
  int randomTalents;
  Race race;
  bool defaultAncestry;

  List<Skill> linkedSkills = [];
  List<SkillGroup> linkedGroupSkills = [];
  List<Talent> linkedTalents = [];
  List<TalentGroup> linkedGroupTalents = [];

  Ancestry(
      {super.id,
      required this.name,
      required this.race,
      this.source = "Custom",
      this.randomTalents = 0,
      this.defaultAncestry = true});

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => super.props
    ..addAll([
      name,
      source,
      randomTalents,
      race,
      defaultAncestry,
      linkedSkills,
      linkedGroupSkills,
      linkedTalents,
      linkedGroupTalents
    ]);
}

class AncestryFactory extends Factory<Ancestry> {
  @override
  get tableName => 'subraces';

  @override
  Map<String, dynamic> get defaultValues => {"RANDOM_TALENTS": 0, "SRC": "Custom", "DEF": 1};

  Future<List<Ancestry>> getAncestryFromRace(int raceId) async {
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
  Future<Ancestry> fromMap(Map<String, dynamic> map) async {
    Ancestry ancestry = Ancestry(
        id: map["ID"] ?? await getNextId(),
        race: await getRace(map),
        name: map["NAME"],
        randomTalents: map["RANDOM_TALENTS"],
        source: map["SRC"],
        defaultAncestry: map["DEF"] == 1);
    ancestry.linkedSkills = await SkillFactory().getLinkedToRace(ancestry.id!);
    ancestry.linkedGroupSkills = await SkillFactory().getGroupsLinkedToAncestry(ancestry.id!);
    ancestry.linkedTalents = await TalentFactory().getLinkedToAncestry(ancestry.id!);
    ancestry.linkedGroupTalents = await TalentFactory().getGroupsLinkedToAncestry(ancestry.id!);
    return ancestry;
  }

  @override
  Future<Ancestry> fromDatabase(Map<String, dynamic> map) async {
    Ancestry ancestry = Ancestry(
        id: map["ID"],
        race: await RaceFactory().get(map["RACE_ID"]),
        name: map["NAME"],
        randomTalents: map["RANDOM_TALENTS"],
        source: map["SRC"],
        defaultAncestry: map["DEF"] == 1);
    ancestry.linkedSkills = await SkillFactory().getLinkedToRace(map["ID"]);
    ancestry.linkedGroupSkills = await SkillFactory().getGroupsLinkedToAncestry(map["ID"]);
    ancestry.linkedTalents = await TalentFactory().getLinkedToAncestry(map["ID"]);
    ancestry.linkedGroupTalents = await TalentFactory().getGroupsLinkedToAncestry(map["ID"]);
    return ancestry;
  }

  @override
  Future<Map<String, dynamic>> toDatabase(Ancestry object, {optimised = true, database = false}) async {
    return {
      "ID": object.id,
      "RACE_ID": object.race.id,
      "NAME": object.name,
      "RANDOM_TALENTS": object.randomTalents,
      "SRC": object.source,
      "DEF": object.defaultAncestry ? 1 : 0
    };
  }

  @override
  Future<Map<String, dynamic>> toMap(Ancestry object, {optimised = true, database = false}) async {
    Map<String, dynamic> map = {
      "ID": object.id,
      "RACE_ID": object.race.id,
      "NAME": object.name,
      "RANDOM_TALENTS": object.randomTalents,
      "SRC": object.source,
      "DEF": object.defaultAncestry ? 1 : 0
    };
    if (optimised) {
      map = await optimise(map);
    }
    return map;
  }
}
