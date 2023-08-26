import 'package:battle_it_out/utils/db_object.dart';
import 'package:flutter/foundation.dart';

class TalentGroup extends DBObject {
  String name;
  bool randomTalent;
  List<dynamic> talents;

  TalentGroup({super.id, required this.name, required this.talents, required this.randomTalent});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TalentGroup &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          randomTalent == other.randomTalent &&
          listEquals(talents, other.talents);

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ randomTalent.hashCode ^ talents.hashCode;

  @override
  String toString() {
    return 'TalentGroup{id: $id, name: $name, randomTalent: $randomTalent, talents: $talents}';
  }
}
