import 'package:battle_it_out/utils/db_object.dart';

class Trait extends DBObject {
  String name;
  String description;

  Trait({super.id, required this.name, required this.description});

  @override
  String toString() {
    return "Trait ($id, $name)";
  }
}
