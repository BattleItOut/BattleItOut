class Talent {
  final int id;
  final String name;
  final String nameEng;
  final int? maxLvl;
  final int? constLvl;
  final String? descr;
  final int grouped;

  Talent({
    required this.id,
    required this.name,
    required this.nameEng,
    this.maxLvl,
    this.constLvl,
    this.descr,
    required this.grouped
  });

  bool isGrouped() {
    return grouped == 1;
  }

  @override
  String toString() {
    return "Talent(id=$id, name=$name)";
  }
}
