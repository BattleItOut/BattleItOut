import 'package:battle_it_out/persistence/race.dart';
import 'package:battle_it_out/persistence/skill/skill.dart';
import 'package:battle_it_out/persistence/skill/skill_group.dart';
import 'package:battle_it_out/persistence/talent/talent.dart';
import 'package:battle_it_out/persistence/talent/talent_group.dart';
import 'package:battle_it_out/providers/skill/skill_group_provider.dart';
import 'package:battle_it_out/providers/skill/skill_provider.dart';
import 'package:battle_it_out/utils/db_object.dart';
import 'package:battle_it_out/utils/lazy.dart';
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
  late Lazy<List<Skill>> skills;
  late Lazy<List<SkillGroup>> groupSkills;

  List<Talent> linkedTalents = [];
  List<TalentGroup> linkedGroupTalents = [];

  Ancestry(
      {super.id,
      required this.name,
      required this.race,
      this.source = "Custom",
      this.randomTalents = 0,
      this.defaultAncestry = true});

  Ancestry.fromData(
      {super.id,
      required this.name,
      required this.race,
      this.source = "Custom",
      this.randomTalents = 0,
      this.defaultAncestry = true}) {
    skills = Lazy<List<Skill>>(() async {
      SkillRepository repository = GetIt.instance.get<SkillRepository>();
      return await repository.getLinkedToAncestry(id!);
    });
    groupSkills = Lazy<List<SkillGroup>>(() async {
      SkillGroupRepository repository = GetIt.instance.get<SkillGroupRepository>();
      return await repository.getLinkedToAncestry(id!);
    });
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props =>
      super.props..addAll([name, source, randomTalents, race, defaultAncestry, linkedTalents, linkedGroupTalents]);
}
