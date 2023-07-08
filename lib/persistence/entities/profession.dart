import 'package:uuid/uuid.dart';

class Profession {
  late String id;
  int? databaseId;
  String name;
  String source;
  int? level;
  ProfessionCareer? career;

  Profession({String? id, this.databaseId, required this.name, this.level, this.source = "Custom", this.career}) {
    this.id = id ?? const Uuid().v4();
  }

  @override
  String toString() {
    return "Profession (id=$id, name=$name, lvl=$level)";
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Profession &&
          runtimeType == other.runtimeType &&
          databaseId == other.databaseId &&
          name == other.name &&
          source == other.source &&
          level == other.level &&
          career == other.career;

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ source.hashCode ^ level.hashCode ^ career.hashCode;
}

class ProfessionCareer {
  late String id;
  int? databaseId;
  String name;
  String source;
  ProfessionClass? professionClass;

  ProfessionCareer({String? id, this.databaseId, required this.name, this.professionClass, required this.source}) {
    this.id = id ?? const Uuid().v4();
  }

  @override
  String toString() {
    return "ProfessionCareer (id=$id, name=$name)";
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProfessionCareer &&
          runtimeType == other.runtimeType &&
          databaseId == other.databaseId &&
          name == other.name &&
          source == other.source &&
          professionClass == other.professionClass;

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ source.hashCode ^ professionClass.hashCode;
}

class ProfessionClass {
  late String id;
  int? databaseId;
  String name;
  String source;

  ProfessionClass({String? id, this.databaseId, required this.name, required this.source}) {
    this.id = id ?? const Uuid().v4();
  }

  @override
  String toString() {
    return "ProfessionClass (id=$id, name=$name)";
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProfessionClass &&
          runtimeType == other.runtimeType &&
          databaseId == other.databaseId &&
          name == other.name &&
          source == other.source;

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ source.hashCode;
}
