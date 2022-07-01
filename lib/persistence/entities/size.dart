class Size {
  int? id;
  String name;
  String source;

  Size({this.id, required this.name, this.source = "Custom"});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Size &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          source == other.source;

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ source.hashCode;

  @override
  String toString() {
    return "Size ($id, $name)";
  }
}
