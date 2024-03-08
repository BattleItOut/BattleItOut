import 'package:battle_it_out/persistence/ancestry.dart';
import 'package:battle_it_out/persistence/attribute.dart';
import 'package:battle_it_out/persistence/size.dart';
import 'package:battle_it_out/providers/ancestry_provider.dart';
import 'package:battle_it_out/providers/attribute_provider.dart';
import 'package:battle_it_out/utils/db_object.dart';
import 'package:battle_it_out/utils/lazy.dart';
import 'package:get_it/get_it.dart';

class RacePartial extends DBObject {
  String? name;
  Size? size;
  String? source;
  Lazy<List<Ancestry>>? ancestries;
  Lazy<List<Attribute>>? initialAttributes;

  RacePartial({super.id, this.name, this.size, this.source, this.ancestries, this.initialAttributes});

  Race toRace() {
    return Race(
        id: id, name: name!, size: size!, source: source!, attributes: initialAttributes!, ancestries: ancestries!);
  }

  RacePartial.from(Race? race)
      : this(
            id: race?.id,
            name: race?.name,
            size: race?.size,
            source: race?.source,
            initialAttributes: race?.attributes,
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
  late Lazy<List<Ancestry>> ancestries;
  late Lazy<List<Attribute>> attributes;

  Race(
      {super.id,
      required this.name,
      required this.size,
      required this.ancestries,
      required this.attributes,
      this.source = "CUSTOM"});

  Race.fromData(
      {super.id,
      required this.name,
      required this.size,
      List<Attribute>? attributes,
      List<Ancestry>? ancestries,
      this.source = "CUSTOM"}) {
    this.attributes = Lazy<List<Attribute>>(attributes, () async {
      AttributeRepository repository = GetIt.instance.get<AttributeRepository>();
      await repository.init();
      return await repository.getInitialAttributes(id!);
    });
    this.ancestries = Lazy<List<Ancestry>>(ancestries, () async {
      AncestryRepository repository = GetIt.instance.get<AncestryRepository>();
      await repository.init();
      return repository.items.where((Ancestry ancestry) => ancestry.race.id == id!).toList();
    });
  }

  static Race copy(Race race) {
    return Race(
      id: race.id,
      name: race.name,
      size: race.size,
      source: race.source,
      attributes: race.attributes,
      ancestries: race.ancestries,
    );
  }

  @override
  List<Object?> get props => super.props..addAll([name, size, source]);
}
