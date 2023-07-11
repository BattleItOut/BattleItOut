class WeaponLength {
  int? id;
  String name;
  String description;
  String source;

  WeaponLength({this.id, required this.name, this.description = "", this.source = "Custom"});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WeaponLength &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          description == other.description &&
          source == other.source;

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ description.hashCode ^ source.hashCode;

  @override
  String toString() {
    return "WeaponLength ($id, $name)";
  }
}
