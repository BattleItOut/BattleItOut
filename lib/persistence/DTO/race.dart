class Race {
  int id;
  String name;
  int size;
  String source;

  Race({required this.id, required this.name, required this.size, required this.source});

  @override
  String toString() {
    return "Race (id=$id, name=$name)";
  }
}

class Subrace {
  int id;
  String name;
  String source;
  int randomTalents;
  bool defaultSubrace;

  Subrace(
      {required this.id,
      required this.name,
      required this.source,
      required this.randomTalents,
      required this.defaultSubrace});

  @override
  String toString() {
    return "Subrace (id=$id, name=$name)";
  }
}
