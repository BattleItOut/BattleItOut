import 'package:battle_it_out/persistence/entities/character/base_character.dart';

class LabelCharacter extends BaseCharacter {
  @override
  get initiativeHidden => true;

  LabelCharacter({required super.name, super.description, super.initiative});
}
