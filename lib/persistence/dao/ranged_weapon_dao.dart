import 'package:battle_it_out/persistence/dao/ammunition_dao.dart';
import 'package:battle_it_out/persistence/dao/item_dao.dart';
import 'package:battle_it_out/persistence/dao/item_quality_dao.dart';
import 'package:battle_it_out/persistence/dao/skill_dao.dart';
import 'package:battle_it_out/persistence/entities/ammunition.dart';
import 'package:battle_it_out/persistence/entities/attribute.dart';
import 'package:battle_it_out/persistence/entities/item_quality.dart';
import 'package:battle_it_out/persistence/entities/ranged_weapon.dart';
import 'package:battle_it_out/persistence/entities/skill.dart';

class RangedWeaponFactory extends ItemFactory<RangedWeapon> {
  Map<int, Skill> skills;
  Map<int, Attribute> attributes;

  RangedWeaponFactory([this.attributes = const {}, this.skills = const {}]);

  @override
  get tableName => 'weapons_ranged';
  @override
  get qualitiesTableName => 'weapons_melee_qualities';

  @override
  fromMap(Map<String, dynamic> map, [Map overrideMap = const {}]) async {
    RangedWeapon rangedWeapon = RangedWeapon(
        id: map["ID"],
        name: map["NAME"],
        range: map["WEAPON_RANGE"],
        twoHanded: map["TWO_HANDED"] == 1,
        useAmmo: map["USE_AMMO"] == 1,
        rangeAttribute: attributes[map["RANGE_ATTRIBUTE"]],
        damage: map["DAMAGE"],
        itemCategory: map["ITEM_CATEGORY"],
        damageAttribute: attributes[map["DAMAGE_ATTRIBUTE"]],
    );
    if (map["SKILL"] != null) {
      rangedWeapon.skill = skills[map['SKILL']] ?? await SkillFactory(attributes).get(map['SKILL']);
    } if (rangedWeapon.id != null) {
      rangedWeapon.qualities = await getQualities(map["ID"]);
    } if (map["QUALITIES"] != null) {
      rangedWeapon.qualities.addAll([for (var tempMap in map["QUALITIES"]) await ItemQualityFactory().create(tempMap)]);
    } if (map["AMMUNITION"] != null) {
      rangedWeapon.ammunition.addAll([for (var tempMap in map["AMMUNITION"]) await AmmunitionFactory().create(tempMap)]);
    }
    return rangedWeapon;
  }

  @override
  Future<Map<String, dynamic>> toMap(RangedWeapon object, [optimised = true]) async {
    Map<String, dynamic> map = {
      "ID": object.id,
      "NAME": object.name,
      "WEAPON_RANGE": object.range,
      "RANGE_ATTRIBUTE": object.rangeAttribute?.id,
      "DAMAGE": object.damage,
      "DAMAGE_ATTRIBUTE": object.damageAttribute?.id,
      "SKILL": object.skill?.id,
      "QUALITIES": [for (ItemQuality quality in object.qualities.where((e) => e.mapNeeded)) await ItemQualityFactory().toMap(quality)],
      "AMMUNITION": [for (Ammunition ammo in object.ammunition) await AmmunitionFactory().toMap(ammo)]

    };
    if (optimised) {
      map = await optimise(map);
      if (object.qualities.isEmpty) {
        map.remove("QUALITIES");
      }
      if (object.ammunition.isEmpty) {
        map.remove("AMMUNITION");
      }
    }
    return map;
  }
}
