import 'package:battle_it_out/persistence/profession/profession_class.dart';
import 'package:battle_it_out/utils/db_object.dart';

class ProfessionCareer extends DBObject {
  String name;
  String source;
  ProfessionClass professionClass;

  ProfessionCareer({super.id, required this.name, required this.professionClass, required this.source});

  @override
  String toString() {
    return "ProfessionCareer (id=$id, name=$name)";
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProfessionCareer &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          source == other.source &&
          professionClass == other.professionClass;

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ source.hashCode ^ professionClass.hashCode;
}
