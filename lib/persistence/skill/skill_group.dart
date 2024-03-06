import 'package:battle_it_out/utils/db_object.dart';

class SkillGroup extends DBObject {
  String name;
  bool closed;
  List<dynamic> skills;

  SkillGroup({super.id, required this.name, this.closed = false, required this.skills});

  @override
  List<Object?> get props => super.props..addAll([name, skills]);
}
