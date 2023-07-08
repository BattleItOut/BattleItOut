import 'package:battle_it_out/persistence/entities/size.dart';
import 'package:uuid/uuid.dart';

class Race {
  late String id;
  int? databaseId;
  String name;
  Size size;
  int extraPoints;
  String source;
  Subrace? subrace;

  Race(
      {String? id,
      this.databaseId,
      required this.name,
      required this.size,
      required this.extraPoints,
      this.source = "Custom",
      this.subrace}) {
    this.id = id ?? const Uuid().v4();
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Race &&
          runtimeType == other.runtimeType &&
          databaseId == other.databaseId &&
          name == other.name &&
          size == other.size &&
          extraPoints == other.extraPoints &&
          source == other.source &&
          subrace == other.subrace;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      size.hashCode ^
      extraPoints.hashCode ^
      source.hashCode ^
      subrace.hashCode;

  @override
  String toString() => "Race ($id, $name)";
}

class Subrace {
  int? id;
  String name;
  String source;
  int randomTalents;
  bool defaultSubrace;

  Subrace(
      {this.id,
      required this.name,
      this.source = "Custom",
      this.randomTalents = 0,
      this.defaultSubrace = true});

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
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      source.hashCode ^
      randomTalents.hashCode ^
      defaultSubrace.hashCode;

  @override
  String toString() => 'Subrace ($id, $name)';
}
