import 'package:battle_it_out/persistence/dao/serializer.dart';
import 'package:battle_it_out/persistence/entities/attribute.dart';

class AttributeFactory extends Factory<Attribute> {
  @override
  get tableName => 'attributes';

  @override
  Attribute fromMap(Map<String, dynamic> map) {
    return Attribute(
        id: map['ID'],
        name: map['NAME'],
        shortName: map["SHORT_NAME"],
        description: map["DESCRIPTION"],
        rollable: map['ROLLABLE'],
        importance: map['IMPORTANCE'],
        base: map["BASE"] ?? 0,
        advances: map["ADVANCES"] ?? 0,
        advancable: map["ADVANCABLE"] ?? false);
  }

  @override
  Map<String, dynamic> toMap(Attribute object) {
    return {
      "ID": object.id,
      "NAME": object.name,
      "SHORT_NAME": object.shortName,
      "DESCRIPTION": object.description,
      "ROLLABLE": object.rollable,
      "IMPORTANCE": object.importance,
      "BASE": object.base,
      "ADVANCES": object.advances,
      "ADVANCABLE": object.advancable
    };
  }
}
