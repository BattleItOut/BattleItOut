import 'package:battle_it_out/providers/ancestry_provider.dart';
import 'package:battle_it_out/providers/attribute_provider.dart';
import 'package:battle_it_out/providers/character_provider.dart';
import 'package:battle_it_out/providers/database_provider.dart';
import 'package:battle_it_out/providers/item/ammunition_provider.dart';
import 'package:battle_it_out/providers/item/armour_provider.dart';
import 'package:battle_it_out/providers/item/item_quality_provider.dart';
import 'package:battle_it_out/providers/item/melee_weapon_provider.dart';
import 'package:battle_it_out/providers/item/ranged_weapon_provider.dart';
import 'package:battle_it_out/providers/item/weapon_length_provider.dart';
import 'package:battle_it_out/providers/profession/profession_career_provider.dart';
import 'package:battle_it_out/providers/profession/profession_class_provider.dart';
import 'package:battle_it_out/providers/profession/profession_provider.dart';
import 'package:battle_it_out/providers/race_provider.dart';
import 'package:battle_it_out/providers/size_provider.dart';
import 'package:battle_it_out/providers/skill/base_skill_provider.dart';
import 'package:battle_it_out/providers/skill/skill_group_provider.dart';
import 'package:battle_it_out/providers/skill/skill_provider.dart';
import 'package:battle_it_out/providers/talent/base_talent_provider.dart';
import 'package:battle_it_out/providers/talent/talent_provider.dart';
import 'package:battle_it_out/providers/talent/talent_test_provider.dart';
import 'package:get_it/get_it.dart';

class Wrapper<T> {
  T? object;

  Wrapper([this.object]);
}

String warning(String text) {
  return '\x1B[33m$text\x1B[0m';
}

void setupGetIt({bool test = false}) {
  GetIt.instance.registerSingleton<AmmunitionRepository>(AmmunitionRepository());
  GetIt.instance.registerSingleton<WeaponLengthRepository>(WeaponLengthRepository());
  GetIt.instance.registerSingleton<MeleeWeaponRepository>(MeleeWeaponRepository());
  GetIt.instance.registerSingleton<RangedWeaponRepository>(RangedWeaponRepository());
  GetIt.instance.registerSingleton<ArmourRepository>(ArmourRepository());
  GetIt.instance.registerSingleton<ProfessionRepository>(ProfessionRepository());
  GetIt.instance.registerSingleton<ProfessionCareerRepository>(ProfessionCareerRepository());
  GetIt.instance.registerSingleton<ProfessionClassRepository>(ProfessionClassRepository());
  GetIt.instance.registerSingleton<AncestryRepository>(AncestryRepository());
  GetIt.instance.registerSingleton<CharacterRepository>(CharacterRepository());
  GetIt.instance.registerSingleton<AttributeRepository>(AttributeRepository());
  GetIt.instance.registerSingleton<BaseSkillRepository>(BaseSkillRepository());
  GetIt.instance.registerSingleton<BaseTalentRepository>(BaseTalentRepository());
  GetIt.instance.registerSingleton<ItemQualityRepository>(ItemQualityRepository());
  GetIt.instance.registerSingleton<DatabaseRepository>(DatabaseRepository(test: test));
  GetIt.instance.registerSingleton<RaceRepository>(RaceRepository());
  GetIt.instance.registerSingleton<SizeRepository>(SizeRepository());
  GetIt.instance.registerSingleton<SkillGroupRepository>(SkillGroupRepository());
  GetIt.instance.registerSingleton<SkillRepository>(SkillRepository());
  GetIt.instance.registerSingleton<TalentRepository>(TalentRepository());
  GetIt.instance.registerSingleton<TalentTestRepository>(TalentTestRepository());
}
