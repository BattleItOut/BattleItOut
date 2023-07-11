import 'package:uuid/uuid.dart';

class WeaponLength {
  late String id;
  int? databaseId;
  String name;
  String description;
  String source;

  WeaponLength({String? id, this.databaseId, required this.name, this.description = "", this.source = "Custom"}) {
    this.id = id ?? const Uuid().v4();
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WeaponLength &&
          runtimeType == other.runtimeType &&
          databaseId == other.databaseId &&
          name == other.name &&
          description == other.description &&
          source == other.source;

  @override
  int get hashCode => databaseId.hashCode ^ name.hashCode ^ description.hashCode ^ source.hashCode;

  @override
  String toString() {
    return "WeaponLength ($id, $name)";
  }
}
