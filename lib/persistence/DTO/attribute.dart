class Attribute {
  int id;
  String name;
  int rollable;
  int importance;
  int base;
  int advances = 0;

  Attribute({required this.id, required this.name, required this.rollable, required this.importance, this.base = 0});

  @override
  String toString() {
    return "Attribute (id=$id, name=$name, base=$base, advances=$advances)";
  }
}
