import 'package:battle_it_out/persistence/ancestry.dart';
import 'package:battle_it_out/persistence/attribute.dart';
import 'package:battle_it_out/persistence/size.dart';
import 'package:battle_it_out/providers/ancestry_provider.dart';
import 'package:battle_it_out/providers/attribute_provider.dart';
import 'package:battle_it_out/utils/db_object.dart';
import 'package:get_it/get_it.dart';

class RacePartial extends DBObject {
  String? name;
  Size? size;
  String? source;
  List<Ancestry>? ancestries;
  List<Attribute>? attributes;

  RacePartial({super.id, this.name, this.size, this.source, this.ancestries, this.attributes});

  Race toRace() {
    return Race(id: id, name: name!, size: size!, source: source!);
  }

  RacePartial.from(Race? race)
      : this(
            id: race?.id,
            name: race?.name,
            size: race?.size,
            source: race?.source,
            attributes: race?.attributes,
            ancestries: race?.ancestries);

  @override
  List<Object?> get props => super.props..addAll([name, size, source]);

  bool compareTo(Race? race) {
    try {
      return toRace() == race;
    } on TypeError catch (_) {
      return false;
    }
  }
}

class Race extends DBObject {
  String name;
  Size size;
  String source;
  List<Ancestry>? _ancestries;
  List<Ancestry> get ancestries => _ancestries!;
  List<Attribute>? _attributes;
  List<Attribute> get attributes => _attributes!;

  Race(
      {super.id,
      required this.name,
      required this.size,
      List<Ancestry>? ancestries,
      List<Attribute>? attributes,
      this.source = "CUSTOM"}) {
    _ancestries = ancestries;
    _attributes = attributes;
  }

  Future<void> fetchAncestries() async {
    AncestryRepository repository = GetIt.instance.get<AncestryRepository>();
    await repository.init();
    _ancestries = repository.items.where((Ancestry ancestry) => ancestry.race.id == id!).toList();
  }

  Future<void> fetchAttributes() async {
    AttributeRepository repository = GetIt.instance.get<AttributeRepository>();
    await repository.init();
    _attributes = await repository.getInitialAttributes(id!);
  }

  @override
  List<Object?> get props => super.props..addAll([name, size, source]);
}
