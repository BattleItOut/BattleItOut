class Armour {
  int id;
  String name;
  int headAP;
  int bodyAP;
  int armsAP;
  int legsAP;

  Armour(
      {required this.id,
        required this.name,
        required this.headAP,
        required this.bodyAP,
        required this.armsAP,
        required this.legsAP});

  @override
  String toString() {
    return "Skill(id=$id, name=$name, AP=$headAP/$bodyAP/$armsAP/$legsAP))";
  }}