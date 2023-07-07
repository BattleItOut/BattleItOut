class Profession {
  int? id;
  String name;
  String source;
  int? level;
  ProfessionCareer? career;

  Profession({this.id, required this.name, this.level, this.source = "Custom", this.career});

  @override
  String toString() {
    return "Profession (id=$id, name=$name, lvl=$level)";
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Profession &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          source == other.source &&
          level == other.level &&
          career == other.career;

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ source.hashCode ^ level.hashCode ^ career.hashCode;
}

class ProfessionCareer {
  int? id;
  String name;
  String source;
  ProfessionClass? professionClass;

  ProfessionCareer({required this.id, required this.name, this.professionClass, required this.source});

  @override
  String toString() {
    return "ProfessionCareer (id=$id, name=$name)";
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ProfessionCareer && runtimeType == other.runtimeType && id == other.id && name == other.name &&
              source == other.source && professionClass == other.professionClass;

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ source.hashCode ^ professionClass.hashCode;
}

class ProfessionClass {
  int? id;
  String name;
  String source;

  ProfessionClass({required this.id, required this.name, required this.source});

  @override
  String toString() {
    return "ProfessionClass (id=$id, name=$name)";
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProfessionClass &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          source == other.source;

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ source.hashCode;
}
