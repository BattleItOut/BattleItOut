import 'package:battle_it_out/persistence/entities/size.dart';

class Subrace {
  int id;
  String name;
  String source;
  int randomTalents;
  bool defaultSubrace;

  Race race;

  Subrace({required this.id, required this.name, required this.race, this.source = "Custom", this.randomTalents = 0, this.defaultSubrace = true});

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

class Race {
  int id;
  String name;
  Size size;
  int extraPoints;
  String source;

  Race(
      {required this.id,
      required this.name,
      required this.size,
      required this.extraPoints,
      this.source = "Custom"});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Race &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          size == other.size &&
          extraPoints == other.extraPoints &&
          source == other.source;

  @override
  int get hashCode =>
      id.hashCode ^ name.hashCode ^ size.hashCode ^ extraPoints.hashCode ^ source.hashCode;

  @override
  String toString() => "Race ($id, $name)";
}
