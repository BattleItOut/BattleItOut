import 'package:battle_it_out/persistence/talent/talent_base.dart';
import 'package:battle_it_out/persistence/talent/talent_test.dart';
import 'package:battle_it_out/utils/db_object.dart';

class Talent extends DBObject {
  String name;
  String? specialisation;
  BaseTalent baseTalent;
  List<TalentTest> tests = [];

  int currentLvl = 0;
  bool canAdvance = false;

  Talent(
      {super.id,
      required this.name,
      this.specialisation,
      required this.baseTalent,
      List<TalentTest> tests = const [],
      this.currentLvl = 0,
      this.canAdvance = false}) {
    this.tests.addAll(tests);
  }

  bool isSpecialised() {
    return specialisation != null;
  }

  int? getMaxLvl() {
    return baseTalent.getMaxLvl();
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Talent &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          specialisation == other.specialisation &&
          baseTalent == other.baseTalent &&
          currentLvl == other.currentLvl &&
          canAdvance == other.canAdvance;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      specialisation.hashCode ^
      baseTalent.hashCode ^
      currentLvl.hashCode ^
      canAdvance.hashCode;

  @override
  String toString() {
    return "Talent (id=$id, name=$name)";
  }
}
