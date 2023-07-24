import 'package:flutter/foundation.dart';

class SkillGroup {
  int? id;
  String name;
  List<dynamic> skills;

  SkillGroup({this.id, required this.name, required this.skills});

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
