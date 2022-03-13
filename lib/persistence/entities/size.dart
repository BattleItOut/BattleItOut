import 'dto.dart';

class Size extends DTO {
  int? id;
  String name;
  String source;

  Size({this.id, required this.name, this.source = "Custom"});

  @override
  Map<String, dynamic> toMap() {
    return {
      "ID": id,
      "NAME": name,
      "SOURCE": source
    };
  }

  @override
  String toString() {
    return "Size ($id, $name)";
  }
}