import 'package:battle_it_out/persistence/wfrp_database.dart';

class Race {
  int id;
  String name;
  String source;

  Race({required this.id, required this.name, required this.source});

  static loadFromDatabase({required int id, required WFRPDatabase database}) async {
    Race race = await database.getRace(id);
    return race;
  }
}