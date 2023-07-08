class Attribute {
  int id;
  String name;
  String shortName;
  String description;
  int rollable;
  int importance;

  int base;
  int advances;
  bool advancable;

  Attribute(
      {required this.id,
      required this.name,
      required this.shortName,
      required this.description,
      required this.rollable,
      required this.importance,
      this.base = 0,
      this.advances = 0,
      this.advancable = false});

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
          id == other.id &&
          name == other.name &&
          shortName == other.shortName &&
          description == other.description &&
          rollable == other.rollable &&
          importance == other.importance;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      shortName.hashCode ^
      description.hashCode ^
      rollable.hashCode ^
      importance.hashCode;

  @override
  String toString() {
    return "Attribute (id=$id, name=$name, base=$base, advances=$advances)";
  }
}
