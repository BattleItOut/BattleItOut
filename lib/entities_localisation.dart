import 'package:battle_it_out/localisation.dart';
import 'package:battle_it_out/persistence/entities/profession.dart';
import 'package:battle_it_out/persistence/entities/race.dart';
import 'package:battle_it_out/persistence/entities/talent.dart';
import 'package:flutter/widgets.dart';

extension RaceLocalisation on Race {
  String getLocalName(BuildContext context) {
    if (subrace != null && name != subrace!.name) {
      return "${AppLocalizations.of(context).localise(name)} (${AppLocalizations.of(context).localise(subrace!.name)})";
    } else {
      return AppLocalizations.of(context).localise(name);
    }
  }
}

extension ProfessionLocalisation on Profession {
  String getLocalName(BuildContext context) {
    if (career != null) {
      return "${AppLocalizations.of(context).localise(name)} (${AppLocalizations.of(context).localise(career!.name)})";
    } else {
      return AppLocalizations.of(context).localise(name);
    }
  }
}

extension TalentTestLocalisation on TalentTest {
  String getLocalName(BuildContext context) {
    String testString = "";
    if (baseSkill != null) {
      testString = "${AppLocalizations.of(context).localise(baseSkill!.name)} ";
    } else if (skill != null) {
      testString = "${AppLocalizations.of(context).localise(skill!.name)} ";
    } else if (attribute != null) {
      testString = "${AppLocalizations.of(context).localise(attribute!.name)} ";
    }

    String commentString = "";
    if (comment != null) {
      if (testString != "") {
        commentString = "(${AppLocalizations.of(context).localise(comment!)}) ";
      } else {
        commentString = "${AppLocalizations.of(context).localise(comment!)} ";
      }
    }

    return "$testString$commentString+${talent?.currentLvl ?? 1} SL";
  }
}

extension StringLocalisation on String {
  String localise(BuildContext context) {
    return AppLocalizations.of(context).localise(this);
  }
}