import 'package:battle_it_out/wfrp_database.dart';

class Attribute {
  int id;
  String name;
  int rollable;
  int importance;
  int base;
  int advances = 0;

  Attribute({required this.id, required this.name, required this.rollable, required this.importance, this.base = 0});
  static fromMap(Map<String, dynamic> map) {
    return Attribute(
        id: map['ID'],
        name: map['NAME'],
        rollable: map['ROLLABLE'],
        importance: map['IMPORTANCE']);
  }
  static create({required int id, required WFRPDatabase database, base, advances}) async {
    Attribute attribute = await database.getAttribute(id);
    attribute.base = base;
    attribute.advances = advances;
    return attribute;
  }
}