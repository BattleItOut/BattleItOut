import 'package:battle_it_out/persistence/race.dart';
import 'package:battle_it_out/persistence/serializer.dart';
import 'package:battle_it_out/persistence/skill/skill.dart';
import 'package:battle_it_out/persistence/skill/skill_group.dart';
import 'package:battle_it_out/persistence/talent/talent.dart';

class Subrace {
  int id;
  String name;
  String source;
  int randomTalents;
  Race race;
  bool defaultSubrace;

  List<Skill> linkedSkills = [];
  List<SkillGroup> linkedGroupSkills = [];
  List<Talent> linkedTalents = [];

  Subrace._(
      {required this.id,
      required this.name,
      required this.race,
      this.source = "Custom",
      this.randomTalents = 0,
      this.defaultSubrace = true});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Subrace &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          source == other.source &&
          randomTalents == other.randomTalents &&
          defaultSubrace == other.defaultSubrace;

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ source.hashCode ^ randomTalents.hashCode ^ defaultSubrace.hashCode;

  @override
  String toString() => 'Subrace ($id, $name)';
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
    Subrace subrace = Subrace._(
        id: map["ID"] ?? await getNextId(),
        race: await getRace(map),
        name: map["NAME"],
        randomTalents: map["RANDOM_TALENTS"],
        source: map["SRC"],
        defaultSubrace: map["DEF"] == 1);
    subrace.linkedSkills = await SkillFactory().getLinkedToRace(subrace.id);
    subrace.linkedGroupSkills = await SkillFactory().getGroupsLinkedToSubrace(subrace.id);
    subrace.linkedTalents = await TalentFactory().getLinkedToRace(subrace.id);
    return subrace;
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
