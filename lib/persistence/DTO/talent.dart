class Talent {
  final int id;
  final String name;
  final String nameEng;
  final int? maxLvl;
  final int? constLvl;
  final String? description;
  final bool grouped;

  Talent({
    required this.id,
    required this.name,
    required this.nameEng,
    this.maxLvl,
    this.constLvl,
    this.description,
    required this.grouped
  });

  @override
  String toString() {
    return "Talent(id=$id, name=$name)";
  }
}
