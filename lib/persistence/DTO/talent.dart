import 'package:battle_it_out/persistence/DTO/attribute.dart';

class Talent {
  int id;
  String name;
  String nameEng;
  Attribute? maxLvl;
  int? constLvl;
  String? description;
  bool grouped;

  int currentLvl = 0;
  bool advancable = false;

  Talent(
      {required this.id,
      required this.name,
      required this.nameEng,
      this.maxLvl,
      this.constLvl,
      this.description,
      required this.grouped});

  @override
  String toString() {
    return "Talent(id=$id, name=$name)";
  }
}
