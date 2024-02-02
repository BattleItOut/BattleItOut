import 'dart:async';

import 'package:battle_it_out/persistence/ancestry.dart';
import 'package:battle_it_out/persistence/race.dart';
import 'package:battle_it_out/providers/race_provider.dart';
import 'package:battle_it_out/utils/factory.dart';
import 'package:get_it/get_it.dart';

class AncestryProvider extends Factory<Ancestry> {
  @override
  get tableName => 'subraces';

  @override
  Map<String, dynamic> get defaultValues => {"RANDOM_TALENTS": 0, "SRC": "Custom", "DEF": 1};

  List<Ancestry>? getAncestryFromRace(int raceId) {
    return items.where((Ancestry ancestry) => ancestry.race.id == raceId).toList();
  }

  Future<Race> getRace(Map<String, dynamic> map) async {
    if (map["RACE_ID"] != null) {
      return (await GetIt.instance.get<RaceProvider>().get(map["RACE_ID"]))!;
    } else if (map["RACE"] != null) {
      return await RaceProvider().create(map["RACE"]);
    } else {
      return await RaceProvider().create(map);
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
    // ancestry.linkedSkills = await SkillFactory().getLinkedToRace(ancestry.id!);
    // ancestry.linkedGroupSkills = await SkillFactory().getGroupsLinkedToAncestry(ancestry.id!);
    // ancestry.linkedTalents = await TalentFactory().getLinkedToAncestry(ancestry.id!);
    // ancestry.linkedGroupTalents = await TalentFactory().getGroupsLinkedToAncestry(ancestry.id!);
    return ancestry;
  }

  @override
  Future<Ancestry> fromDatabase(Map<String, dynamic> map) async {
    Ancestry ancestry = Ancestry(
        id: map["ID"],
        race: (await GetIt.instance.get<RaceProvider>().get(map["RACE_ID"]))!,
        name: map["NAME"],
        randomTalents: map["RANDOM_TALENTS"],
        source: map["SRC"],
        defaultAncestry: map["DEF"] == 1);
    // ancestry.linkedSkills = await SkillFactory().getLinkedToRace(map["ID"]);
    // ancestry.linkedGroupSkills = await SkillFactory().getGroupsLinkedToAncestry(map["ID"]);
    // ancestry.linkedTalents = await TalentFactory().getLinkedToAncestry(map["ID"]);
    // ancestry.linkedGroupTalents = await TalentFactory().getGroupsLinkedToAncestry(map["ID"]);
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
