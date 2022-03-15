import 'package:battle_it_out/localisation.dart';
import 'package:battle_it_out/persistence/entities/profession.dart';
import 'package:battle_it_out/persistence/entities/race.dart';
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

extension StringLocalisation on String {
  String localise(BuildContext context) {
    return AppLocalizations.of(context).localise(this);
  }
}