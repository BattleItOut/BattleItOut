import 'package:battle_it_out/persistence/attribute.dart';
import 'package:battle_it_out/persistence/item/ammunition.dart';
import 'package:battle_it_out/persistence/item/item_quality.dart';
import 'package:battle_it_out/persistence/item/ranged_weapon.dart';
import 'package:battle_it_out/persistence/skill/skill.dart';
import 'package:battle_it_out/providers/item/abstract_item_provider.dart';
import 'package:battle_it_out/providers/item/ammunition_provider.dart';
import 'package:battle_it_out/providers/item/item_quality_provider.dart';
import 'package:battle_it_out/providers/skill/skill_provider.dart';
import 'package:collection/collection.dart';
import 'package:get_it/get_it.dart';

class RangedWeaponRepository extends AbstractItemRepository<RangedWeapon> {
  List<Skill>? skills;
  List<Attribute>? attributes;

  RangedWeaponRepository([this.attributes, this.skills]);

  @override
  Future<void> init() async {
    await GetIt.instance.get<SkillRepository>().init();
    await GetIt.instance.get<AmmunitionRepository>().init();
    await super.init();
  }

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
      rangedWeapon.skill = skill ?? await GetIt.instance.get<SkillRepository>().get(map['SKILL']);
    }
    if (map["ID"] != null) {
      rangedWeapon.qualities = await getQualities(map["ID"]);
    }
    if (map["QUALITIES"] != null) {
      for (Map<String, dynamic> map in map["QUALITIES"]) {
        ItemQuality quality = await GetIt.instance.get<ItemQualityRepository>().create(map);
        if (!rangedWeapon.qualities.contains(quality)) {
          rangedWeapon.qualities.add(quality);
        }
      }
    }
    if (map["AMMUNITION"] != null) {
      rangedWeapon.ammunition.addAll(
          [for (var tempMap in map["AMMUNITION"]) await GetIt.instance.get<AmmunitionRepository>().create(tempMap)]);
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
      "QUALITIES": [
        for (ItemQuality quality in object.qualities)
          await GetIt.instance.get<ItemQualityRepository>().toDatabase(quality)
      ],
      "AMMUNITION": [
        for (Ammunition ammo in object.ammunition) await GetIt.instance.get<AmmunitionRepository>().toDatabase(ammo)
      ]
    };
    if (optimised) {
      map = await optimise(map);
    }
    return map;
  }
}
