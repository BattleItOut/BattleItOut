import 'package:battle_it_out/persistence/attribute.dart';
import 'package:battle_it_out/persistence/item/item.dart';
import 'package:battle_it_out/persistence/item/item_quality.dart';
import 'package:battle_it_out/persistence/item/weapon.dart';
import 'package:battle_it_out/persistence/item/weapon_length.dart';
import 'package:battle_it_out/persistence/skill/skill.dart';

class MeleeWeapon extends Weapon {
  WeaponLength length;

  MeleeWeapon._(
      {required name,
      required this.length,
      required damage,
      required twoHanded,
      id,
      damageAttribute,
      skill,
      List<ItemQuality> qualities = const []})
      : super(
            id: id,
            name: name,
            qualities: qualities,
            damage: damage,
            twoHanded: twoHanded,
            damageAttribute: damageAttribute,
            itemCategory: "MELEE_WEAPONS",
            skill: skill);

  int getTotalSkillValue() {
    return skill!.getTotalValue();
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other && other is MeleeWeapon && runtimeType == other.runtimeType && length == other.length;

  @override
  int get hashCode => super.hashCode ^ length.hashCode;

  @override
  String toString() {
    return 'MeleeWeapon{length: $length}';
  }
}

class MeleeWeaponFactory extends ItemFactory<MeleeWeapon> {
  List<Skill>? skills;
  List<Attribute>? attributes;

  MeleeWeaponFactory([this.attributes, this.skills]);

  @override
  get tableName => 'weapons_melee';
  @override
  get qualitiesTableName => 'item_qualities';
  @override
  get linkTableName => 'weapons_melee_qualities';

  @override
  Map<String, dynamic> get defaultValues => {"DAMAGE_ATTRIBUTE": 3, "ITEM_CATEGORY": "MELEE_WEAPONS"};

  @override
  Future<MeleeWeapon> fromDatabase(Map<String, dynamic> map) async {
    defaultValues.forEach((key, value) {
      map.putIfAbsent(key, () => value);
    });
    Attribute? damageAttribute = attributes?.firstWhere((attribute) => attribute.id == map["DAMAGE_ATTRIBUTE"]);
    MeleeWeapon meleeWeapon = MeleeWeapon._(
        id: map["ID"],
        name: map["NAME"],
        length: await WeaponLengthFactory().get(map["LENGTH"]),
        damage: map["DAMAGE"],
        twoHanded: map["TWO_HANDED"] == 1,
        damageAttribute: damageAttribute);
    if (map["SKILL"] != null) {
      Skill? skill = skills?.firstWhere((element) => element.id == map['SKILL']);
      meleeWeapon.skill = skill ?? await SkillFactory(attributes).get(map['SKILL']);
    }
    if (map["ID"] != null) {
      meleeWeapon.qualities = await getQualities(map["ID"]);
    }
    if (map["QUALITIES"] != null) {
      for (Map<String, dynamic> map in map["QUALITIES"]) {
        ItemQuality quality = await ItemQualityFactory().fromDatabase(map);
        if (!meleeWeapon.qualities.contains(quality)) {
          meleeWeapon.qualities.add(quality);
        }
      }
    }
    return meleeWeapon;
  }

  @override
  Future<Map<String, dynamic>> toDatabase(MeleeWeapon object) async {
    return {
      "ID": object.id,
      "NAME": object.name,
      "LENGTH": object.length.id,
      "DAMAGE": object.damage,
      "SKILL": object.skill?.id,
      "DAMAGE_ATTRIBUTE": object.damageAttribute?.id,
      "ITEM_CATEGORY": object.category,
    };
  }

  // @override
  // Future<Map<String, dynamic>> toMap(MeleeWeapon object, {optimised = true, database = false}) async {
  //   Map<String, dynamic> map = {
  //     "ID": object.id,
  //     "NAME": object.name,
  //     "LENGTH": object.length.id,
  //     "DAMAGE": object.damage,
  //     "SKILL": object.skill?.id,
  //     "DAMAGE_ATTRIBUTE": object.damageAttribute?.id,
  //     "ITEM_CATEGORY": object.category,
  //   };
  //   if (!database) {
  //     map["QUALITIES"] = [for (ItemQuality quality in object.qualities) await ItemQualityFactory().toDatabase(quality)];
  //     if (optimised) {
  //       map = await optimise(map);
  //     }
  //   }
  //   return map;
  // }
}
