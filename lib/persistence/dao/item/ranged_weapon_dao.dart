import 'package:battle_it_out/persistence/dao/item/ammunition_dao.dart';
import 'package:battle_it_out/persistence/dao/item/item_dao.dart';
import 'package:battle_it_out/persistence/dao/item/item_quality_dao.dart';
import 'package:battle_it_out/persistence/dao/skill_dao.dart';
import 'package:battle_it_out/persistence/entities/attribute.dart';
import 'package:battle_it_out/persistence/entities/item/ammunition.dart';
import 'package:battle_it_out/persistence/entities/item/item_quality.dart';
import 'package:battle_it_out/persistence/entities/item/ranged_weapon.dart';
import 'package:battle_it_out/persistence/entities/skill.dart';

class RangedWeaponFactory extends ItemFactory<RangedWeapon> {
  List<Skill>? skills;
  List<Attribute>? attributes;

  RangedWeaponFactory([this.attributes, this.skills]);

  @override
  get tableName => 'weapons_ranged';
  @override
  get qualitiesTableName => 'item_qualities';
  @override
  get linkTableName => 'weapons_ranged_qualities';

  @override
  Map<String, dynamic> get defaultValues => {"ITEM_CATEGORY": "RANGED_WEAPONS"};

  @override
  Future<RangedWeapon> fromMap(Map<String, dynamic> map) async {
    Attribute? rangeAttribute;
    if (map["RANGE_ATTRIBUTE"] != null) {
      rangeAttribute = attributes?.firstWhere((attribute) => attribute.id == map["RANGE_ATTRIBUTE"]);
    }
    Attribute? damageAttribute;
    if (map["RANGE_ATTRIBUTE"] != null) {
      damageAttribute = attributes?.firstWhere((attribute) => attribute.id == map["DAMAGE_ATTRIBUTE"]);
    }
    RangedWeapon rangedWeapon = RangedWeapon(
      id: map["ID"] ?? await getNextId(),
      name: map["NAME"],
      range: map["WEAPON_RANGE"],
      twoHanded: map["TWO_HANDED"] == 1,
      useAmmo: map["USE_AMMO"] == 1,
      rangeAttribute: rangeAttribute,
      damage: map["DAMAGE"],
      itemCategory: map["ITEM_CATEGORY"],
      damageAttribute: damageAttribute,
    );
    if (map["SKILL"] != null) {
      Skill? skill = skills?.firstWhere((element) => element.id == map['SKILL']);
      rangedWeapon.skill = skill ?? await SkillFactory(attributes).get(map['SKILL']);
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
      rangedWeapon.ammunition.addAll([for (var tempMap in map["AMMUNITION"]) await AmmunitionFactory().create(tempMap)]);
    }
    return rangedWeapon;
  }

  @override
  Future<Map<String, dynamic>> toMap(RangedWeapon object, {optimised = true, database = false}) async {
    Map<String, dynamic> map = {
      "ID": object.id,
      "NAME": object.name,
      "WEAPON_RANGE": object.range,
      "RANGE_ATTRIBUTE": object.rangeAttribute?.id,
      "DAMAGE": object.damage,
      "DAMAGE_ATTRIBUTE": object.damageAttribute?.id,
      "SKILL": object.skill?.id,
      "USE_AMMO": object.useAmmo ? 1 : 0
    };
    if (!database) {
      if (object.qualities.isNotEmpty) {
        map["QUALITIES"] = [for (ItemQuality quality in object.qualities) await ItemQualityFactory().toMap(quality)];
      }
      if (object.ammunition.isNotEmpty) {
        map["AMMUNITION"] = [for (Ammunition ammo in object.ammunition) await AmmunitionFactory().toMap(ammo)];
      }
      if (optimised) {
        map = await optimise(map);
      }
    }
    return map;
  }
}
