import 'dto.dart';

class WeaponLength extends DTO {
  int? id;
  String name;
  String description;
  String source;

  WeaponLength({this.id, required this.name, this.description = "", this.source = "Custom"});

  @override
  Map<String, dynamic> toMap() {
    return {"ID": id, "NAME": name, "DESCRIPTION": description, "SOURCE": source};
  }

  @override
  String toString() {
    return "WeaponLength ($id, $name)";
  }
}
