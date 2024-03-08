import 'package:battle_it_out/persistence/attribute.dart';
import 'package:battle_it_out/utils/db_object.dart';

class BaseTalent extends DBObject {
  String name;
  String? description;
  String source;
  Attribute? attribute;
  int? attributeID;
  int? constLvl;
  bool grouped;

  BaseTalent(
      {super.id,
      required this.name,
      required this.source,
      this.description,
      this.attribute,
      this.constLvl,
      required this.grouped});

  int? getMaxLvl() {
    if (attribute != null) {
      return attribute!.getTotalValue() ~/ 10;
    }
    if (constLvl != null) {
      return constLvl;
    }
    return null;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BaseTalent &&
          id == other.id &&
          name == other.name &&
          description == other.description &&
          source == other.source &&
          grouped == other.grouped &&
          attributeID == other.attributeID &&
          constLvl == other.constLvl;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      description.hashCode ^
      constLvl.hashCode ^
      source.hashCode ^
      grouped.hashCode ^
      attributeID.hashCode;
}
