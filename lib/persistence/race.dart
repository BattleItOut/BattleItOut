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
        id: id,
        name: name!,
        size: size!,
        source: source!,
        initialAttributes: initialAttributes!,
        ancestries: ancestries!);
  }

  RacePartial.from(Race? race)
      : this(
            id: race?.id,
            name: race?.name,
            size: race?.size,
            source: race?.source,
            initialAttributes: race?.initialAttributes,
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
  late Lazy<List<Attribute>> initialAttributes;

  Race(
      {super.id,
      required this.name,
      required this.size,
      required this.ancestries,
      required this.initialAttributes,
      this.source = "CUSTOM"});

  Race.fromData(
      {super.id,
      required this.name,
      required this.size,
      List<Attribute>? initialAttributes,
      List<Ancestry>? ancestries,
      this.source = "CUSTOM"}) {
    this.initialAttributes = Lazy<List<Attribute>>(initialAttributes, () async {
      AttributeProvider provider = GetIt.instance.get<AttributeProvider>();
      await provider.init();
      return await provider.getInitialAttributes(id!);
    });
    this.ancestries = Lazy<List<Ancestry>>(ancestries, () async {
      AncestryProvider provider = GetIt.instance.get<AncestryProvider>();
      await provider.init();
      return provider.items.where((Ancestry ancestry) => ancestry.race.id == id!).toList();
    });
  }

  static Race copy(Race race) {
    return Race(
      id: race.id,
      name: race.name,
      size: race.size,
      source: race.source,
      initialAttributes: race.initialAttributes,
      ancestries: race.ancestries,
    );
  }

  @override
  List<Object?> get props => super.props..addAll([name, size, source]);
}
