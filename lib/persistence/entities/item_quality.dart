class ItemQuality {
  int id;
  String name;
  bool positive;
  String equipment;
  String description;
  int? value;

  ItemQuality(
      {required this.id,
      required this.name,
      required this.positive,
      required this.equipment,
      required this.description,
      this.value});

  @override
  String toString() {
    if (value == null) {
      return "Quality (id=$id, name=$name)";
    } else {
      return "Quality (id=$id, name=$name $value)";
    }
  }
}
