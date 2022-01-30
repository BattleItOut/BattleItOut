import 'package:battle_it_out/persistence/wfrp_database.dart';

class Race {
  int id;
  String name;
  int size;
  String source;

  Race({required this.id, required this.name, required this.size, required this.source});

  static loadFromDatabase({required int id, required WFRPDatabase database}) async {
    Race race = await database.getRace(id);
    return race;
  }
}
class Subrace {
  int id;
  String name;
  String source;
  int randomTalents;
  bool defaultSubrace;

  Subrace({
    required this.id,
    required this.name,
    required this.source,
    required this.randomTalents,
    required this.defaultSubrace});

  static loadFromDatabase({required int id, required WFRPDatabase database}) async {
    Subrace subrace = await database.getSubrace(id);
    return subrace;
  }
}