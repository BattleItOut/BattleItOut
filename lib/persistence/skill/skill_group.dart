import 'package:battle_it_out/utils/db_object.dart';
import 'package:flutter/foundation.dart';

class SkillGroup extends DBObject {
  String name;
  List<dynamic> skills;

  SkillGroup({super.id, required this.name, required this.skills});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SkillGroup &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          listEquals(skills, other.skills);

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ skills.hashCode;

  @override
  String toString() {
    return 'SkillGroup{id: $id, name: $name, skills: $skills}';
  }
}
