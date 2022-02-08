class ItemQuality {
  int id;
  String name;
  String nameEng;
  String type;
  String equipment;
  String description;

  ItemQuality(
      {required this.id,
      required this.name,
      required this.nameEng,
      required this.type,
      required this.equipment,
      required this.description});

  @override
  String toString() {
    return "Quality(id=$id, name=$name)";
  }
}
