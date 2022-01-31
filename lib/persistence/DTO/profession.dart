class Profession {
  int id;
  String name;
  String nameEng;
  int level;
  String source;
  ProfessionCareer career;

  Profession(
      {required this.id,
      required this.name,
      required this.nameEng,
      required this.level,
      required this.source,
      required this.career});

  @override
  String toString() {
    return "Profession (id=$id, name=$name, lvl=$level)";
  }
}

class ProfessionCareer {
  int id;
  String name;
  ProfessionClass professionClass;

  ProfessionCareer({required this.id, required this.name, required this.professionClass});

  @override
  String toString() {
    return "ProfessionCareer (id=$id, name=$name)";
  }
}

class ProfessionClass {
  int id;
  String name;

  ProfessionClass({required this.id, required this.name});

  @override
  String toString() {
    return "ProfessionClass (id=$id, name=$name)";
  }
}
