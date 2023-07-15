abstract class BaseCharacter {
  String name;
  String? description;

  // Temporary
  int? initiative;

  get initiativeHidden;

  BaseCharacter({required this.name, this.description, this.initiative});
}
