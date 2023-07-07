
class Trait {
  int id;
  String name;
  String description;

  Trait({required this.id, required this.name, required this.description});

  @override
  String toString() {
    return "Trait ($id, $name)";
  }
}
