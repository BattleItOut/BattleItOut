import 'package:uuid/uuid.dart';

class Trait {
  late String id;
  int? databaseId;
  String name;
  String description;

  Trait({String? id, this.databaseId, required this.name, required this.description}) {
    this.id = id ?? const Uuid().v4();
  }

  @override
  String toString() {
    return "Trait ($id, $name)";
  }
}
