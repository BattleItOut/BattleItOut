import 'package:uuid/uuid.dart';

class ItemQuality {
  late String id;
  int? databaseId;
  String name;
  bool positive;
  String equipment;
  String description;
  int? value;

  bool mapNeeded = true;

  ItemQuality(
      {String? id,
      this.databaseId,
      required this.name,
      required this.positive,
      required this.equipment,
      required this.description,
      this.value}) {
    this.id = id ?? const Uuid().v4();
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ItemQuality &&
          runtimeType == other.runtimeType &&
          databaseId == other.databaseId &&
          name == other.name &&
          positive == other.positive &&
          equipment == other.equipment &&
          description == other.description &&
          value == other.value &&
          mapNeeded == other.mapNeeded;

  @override
  int get hashCode =>
      databaseId.hashCode ^
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
