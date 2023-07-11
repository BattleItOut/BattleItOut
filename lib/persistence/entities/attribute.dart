import 'package:uuid/uuid.dart';

class Attribute {
  late String id;
  int? databaseId;
  String name;
  String shortName;
  String description;
  int rollable;
  int importance;

  int base;
  int advances;
  bool advancable;

  Attribute(
      {String? id,
      this.databaseId,
      required this.name,
      required this.shortName,
      required this.description,
      required this.rollable,
      required this.importance,
      this.base = 0,
      this.advances = 0,
      this.advancable = false}) {
    this.id = id ?? const Uuid().v4();
  }

  int getTotalValue() {
    return base + advances;
  }

  int getTotalBonus() {
    return getTotalValue() ~/ 10;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Attribute &&
          runtimeType == other.runtimeType &&
          databaseId == other.databaseId &&
          name == other.name &&
          shortName == other.shortName &&
          description == other.description &&
          rollable == other.rollable &&
          importance == other.importance;

  @override
  int get hashCode =>
      databaseId.hashCode ^ name.hashCode ^ shortName.hashCode ^ description.hashCode ^ rollable.hashCode ^ importance.hashCode;

  @override
  String toString() {
    return "Attribute (id=$id, name=$name, base=$base, advances=$advances)";
  }
}
