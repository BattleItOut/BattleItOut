class ItemQuality {
  int id;
  String name;
  String nameEng;
  String type;
  String equipment;
  String description;
  int? value;

  ItemQuality(
      {required this.id,
      required this.name,
      required this.nameEng,
      required this.type,
      required this.equipment,
      required this.description,
      this.value});

  @override
  String toString() {
    if (value == null) {
      return "Quality(id=$id, name=$name)";
    } else {
      return "Quality(id=$id, name=$name $value)";
    }
  }
}
