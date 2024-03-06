import 'package:battle_it_out/persistence/attribute.dart';
import 'package:battle_it_out/persistence/item/ammunition.dart';
import 'package:battle_it_out/persistence/item/item.dart';
import 'package:battle_it_out/persistence/item/item_quality.dart';
import 'package:battle_it_out/persistence/item/weapon.dart';
import 'package:battle_it_out/persistence/skill/skill.dart';
import 'package:battle_it_out/providers/skill_provider.dart';
import 'package:collection/collection.dart';

class RangedWeapon extends Weapon {
  int range;
  Attribute? rangeAttribute;
  bool useAmmo;
  List<Ammunition> ammunition = [];

  RangedWeapon(
      {super.id,
      required super.name,
      required this.range,
      required this.useAmmo,
      required super.damage,
      required super.damageAttribute,
      this.rangeAttribute,
      super.twoHanded,
      super.skill,
      super.qualities = const [],
      List<Ammunition> ammunition = const []})
      : super(category: "RANGED_WEAPONS") {
    this.ammunition.addAll(ammunition);
  }

  int getRange([Ammunition? ammo]) {
    int value = rangeAttribute?.getTotalBonus() ?? 1 * range;
    if (ammo != null) {
      value = (value * ammo.rangeModifier).toInt() + ammo.rangeBonus;
    }
    return value;
  }

  @override
  int getTotalDamage([Ammunition? ammo]) {
    int value = super.getTotalDamage();
    if (ammo != null) {
      value + ammo.damageBonus;
    }
    return value;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is RangedWeapon &&
          runtimeType == other.runtimeType &&
          range == other.range &&
          rangeAttribute == other.rangeAttribute &&
          useAmmo == other.useAmmo;

  @override
  int get hashCode => super.hashCode ^ range.hashCode ^ rangeAttribute.hashCode ^ useAmmo.hashCode;

  @override
  String toString() {
    return 'RangedWeapon{range: $range, rangeAttribute: $rangeAttribute, useAmmo: $useAmmo, ammunition: $ammunition}';
  }
}

class RangedWeaponFactory extends ItemFactory<RangedWeapon> {
  List<Skill>? skills;
  List<Attribute>? attributes;

  RangedWeaponFactory([this.attributes, this.skills]);

  @override
  get tableName => 'weapons_ranged';
  @override
  get linkTableName => 'weapons_ranged_qualities';

  @override
  Map<String, dynamic> get defaultValues => {"ITEM_CATEGORY": "RANGED_WEAPONS"};

  @override
  Future<RangedWeapon> fromDatabase(Map<String, dynamic> map) async {
    Attribute? rangeAttribute;
    if (map["RANGE_ATTRIBUTE"] != null) {
      rangeAttribute = attributes?.firstWhereOrNull((attribute) => attribute.id == map["RANGE_ATTRIBUTE"]);
    }
    Attribute? damageAttribute;
    if (map["RANGE_ATTRIBUTE"] != null) {
      damageAttribute = attributes?.firstWhereOrNull((attribute) => attribute.id == map["DAMAGE_ATTRIBUTE"]);
    }
    RangedWeapon rangedWeapon = RangedWeapon(
      id: map["ID"],
      name: map["NAME"],
      range: map["WEAPON_RANGE"],
      twoHanded: map["TWO_HANDED"] == 1,
      useAmmo: map["USE_AMMO"] == 1,
      rangeAttribute: rangeAttribute,
      damage: map["DAMAGE"],
      damageAttribute: damageAttribute,
    );
    if (map["SKILL"] != null) {
      Skill? skill = skills?.firstWhereOrNull((element) => element.id == map['SKILL']);
      rangedWeapon.skill = skill ?? await SkillProvider().get(map['SKILL']);
    }
    if (map["ID"] != null) {
      rangedWeapon.qualities = await getQualities(map["ID"]);
    }
    if (map["QUALITIES"] != null) {
      for (Map<String, dynamic> map in map["QUALITIES"]) {
        ItemQuality quality = await ItemQualityFactory().create(map);
        if (!rangedWeapon.qualities.contains(quality)) {
          rangedWeapon.qualities.add(quality);
        }
      }
    }
    if (map["AMMUNITION"] != null) {
      rangedWeapon.ammunition
          .addAll([for (var tempMap in map["AMMUNITION"]) await AmmunitionFactory().create(tempMap)]);
    }
    return rangedWeapon;
  }

  @override
  Future<Map<String, dynamic>> toDatabase(RangedWeapon object) async {
    return {
      "ID": object.id,
      "NAME": object.name,
      "WEAPON_RANGE": object.range,
      "RANGE_ATTRIBUTE": object.rangeAttribute?.id,
      "DAMAGE": object.damage,
      "DAMAGE_ATTRIBUTE": object.damageAttribute?.id,
      "SKILL": object.skill?.id,
      "USE_AMMO": object.useAmmo ? 1 : 0
    };
  }

  @override
  Future<Map<String, dynamic>> toMap(RangedWeapon object, {optimised = true}) async {
    Map<String, dynamic> map = {
      "ID": object.id,
      "NAME": object.name,
      "WEAPON_RANGE": object.range,
      "RANGE_ATTRIBUTE": object.rangeAttribute?.id,
      "DAMAGE": object.damage,
      "DAMAGE_ATTRIBUTE": object.damageAttribute?.id,
      "SKILL": object.skill?.id,
      "USE_AMMO": object.useAmmo ? 1 : 0,
      "QUALITIES": [for (ItemQuality quality in object.qualities) await ItemQualityFactory().toDatabase(quality)],
      "AMMUNITION": [for (Ammunition ammo in object.ammunition) await AmmunitionFactory().toDatabase(ammo)]
    };
    if (optimised) {
      map = await optimise(map);
    }
    return map;
  }
}
