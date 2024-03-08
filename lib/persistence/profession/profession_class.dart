import 'package:battle_it_out/utils/db_object.dart';

class ProfessionClass extends DBObject {
  String name;
  String source;

  ProfessionClass({super.id, required this.name, required this.source});

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
