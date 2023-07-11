import 'package:uuid/uuid.dart';

class Size {
  String? id;
  int? databaseId;
  String name;
  String source;

  Size({String? id, this.databaseId, required this.name, this.source = "Custom"}) {
    this.id = id ?? const Uuid().v4();
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Size &&
          runtimeType == other.runtimeType &&
          databaseId == other.databaseId &&
          name == other.name &&
          source == other.source;

  @override
  int get hashCode => databaseId.hashCode ^ name.hashCode ^ source.hashCode;

  @override
  String toString() {
    return "Size ($id, $name)";
  }
}
