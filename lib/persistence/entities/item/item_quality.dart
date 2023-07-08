class ItemQuality {
  int id;
  String name;
  bool positive;
  String equipment;
  String description;
  int? value;

  bool mapNeeded = true;

  ItemQuality(
      {required this.id,
      required this.name,
      required this.positive,
      required this.equipment,
      required this.description,
      this.value});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ItemQuality &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          positive == other.positive &&
          equipment == other.equipment &&
          description == other.description &&
          value == other.value &&
          mapNeeded == other.mapNeeded;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      positive.hashCode ^
      equipment.hashCode ^
      description.hashCode ^
      value.hashCode ^
      mapNeeded.hashCode;

  @override
  String toString() {
    if (value == null) {
      return "Quality (id=$id, name=$name)";
    } else {
      return "Quality (id=$id, name=$name $value)";
    }
  }
}
