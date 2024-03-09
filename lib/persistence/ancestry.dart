import 'package:battle_it_out/persistence/race.dart';
import 'package:battle_it_out/persistence/skill/skill.dart';
import 'package:battle_it_out/persistence/skill/skill_group.dart';
import 'package:battle_it_out/persistence/talent/talent.dart';
import 'package:battle_it_out/persistence/talent/talent_group.dart';
import 'package:battle_it_out/providers/skill/skill_group_provider.dart';
import 'package:battle_it_out/providers/skill/skill_provider.dart';
import 'package:battle_it_out/utils/db_object.dart';
import 'package:get_it/get_it.dart';

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
  List<Skill>? _skills;
  List<Skill> get skills => _skills!;
  List<SkillGroup>? _groupSkills;
  List<SkillGroup> get groupSkills => _groupSkills!;

  List<Talent> linkedTalents = [];
  List<TalentGroup> linkedGroupTalents = [];

  Ancestry(
      {super.id,
      required this.name,
      required this.race,
      List<Skill>? skills,
      List<SkillGroup>? groupSkills,
      this.source = "Custom",
      this.randomTalents = 0,
      this.defaultAncestry = true}) {
    _skills = skills;
    _groupSkills = groupSkills;
  }

  Future<void> fetchSkills() async {
    SkillRepository repository = GetIt.instance.get<SkillRepository>();
    _skills = await repository.getLinkedToAncestry(id!);
  }

  Future<void> fetchGroupSkills() async {
    SkillGroupRepository repository = GetIt.instance.get<SkillGroupRepository>();
    _groupSkills = await repository.getLinkedToAncestry(id!);
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props =>
      super.props..addAll([name, source, randomTalents, race, defaultAncestry, linkedTalents, linkedGroupTalents]);
}
