import 'package:battle_it_out/persistence/attribute.dart';
import 'package:battle_it_out/utils/db_object.dart';

class BaseSkill extends DBObject {
  String name;
  String? description;
  bool advanced;
  bool grouped;
  Attribute attribute;

  BaseSkill(
      {super.id,
      required this.name,
      this.description,
      required this.attribute,
      required this.advanced,
      required this.grouped});

  int getTotalValue() {
    return attribute.getTotalValue();
  }

  Attribute? getAttribute() {
    return attribute;
  }

  @override
  List<Object?> get props => super.props..addAll([name, description, advanced, attribute]);
}
