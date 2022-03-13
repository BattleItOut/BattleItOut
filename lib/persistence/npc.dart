import 'package:battle_it_out/persistence/character.dart';
import 'package:battle_it_out/persistence/entities/profession.dart';
import 'package:battle_it_out/persistence/entities/size.dart';

import 'entities/race.dart';

class NPC extends Character {
  NPC(String name) : super(
    name: name,
    race: Race(
      name: "",
      size: Size(name: "")
    ),
    profession: Profession(
      name: "",
      career: ProfessionCareer(
        name: "",
        professionClass: ProfessionClass(
          id: 2147483647,
          name: ""
        )
      )
    ),
    attributes: {},
  );
}
