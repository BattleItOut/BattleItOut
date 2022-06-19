import 'dto.dart';

class Trait extends DTO {
  int id;
  String name;
  String description;

  Trait({required this.id, required this.name, required this.description});

  @override
  Map<String, dynamic> toMap() {
    return {"ID": id, "NAME": name, "DESCRIPTION": description};
  }

  @override
  String toString() {
    return "Trait ($id, $name)";
  }
}
