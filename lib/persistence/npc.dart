import 'package:battle_it_out/persistence/character.dart';
import 'package:battle_it_out/persistence/entities/profession.dart';

import 'entities/race.dart';

class NPC extends Character {
  NPC(String name) : super(
    name: name,
    race: Race(
      id: 2147483647,
      name: "",
      size: 0,
      extraPoints: 0,
      source: ""
    ),
    subrace: Subrace(
      id: 0,
      name: "",
      source: "",
      randomTalents: 0,
      defaultSubrace: true
    ),
    profession: Profession(
      id: 2147483647,
      name: "",
      nameEng: "",
      level: 2147483647,
      source: "",
      career: ProfessionCareer(
        id: 2147483647,
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
