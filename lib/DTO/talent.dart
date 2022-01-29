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

  static fromMap(Map<String, dynamic> map) {
    return Talent(
        id: map['ID'],
        name: map['NAME'],
        nameEng: map['NAME_ENG'],
        maxLvl: map['MAX_LVL'],
        constLvl: map['CONST_LVL'],
        descr: map['DESCR'],
        grouped: map['GROUPED']);
  }

  bool isGrouped() {
    return grouped == 1;
  }

  @override
  String toString() {
    return "Talent(id=$id, name=$name)";
  }
}
