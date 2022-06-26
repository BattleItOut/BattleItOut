import 'package:battle_it_out/persistence/dao/item_dao.dart';
import 'package:battle_it_out/persistence/dao/item_quality_dao.dart';
import 'package:battle_it_out/persistence/dao/skill_dao.dart';
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
  Future<RangedWeapon> fromMap(Map<String, dynamic> map, [Map overrideMap = const {}]) async {
    RangedWeapon rangedWeapon = RangedWeapon(
        id: map["ID"],
        name: map["NAME"],
        range: map["WEAPON_RANGE"],
        rangeAttribute: attributes[map["RANGE_ATTRIBUTE"]],
        damage: map["DAMAGE"],
        damageAttribute: attributes[map["DAMAGE_ATTRIBUTE"]],
        ammunition: map["AMMUNITION"] ?? 0);
    if (map["SKILL"] != null) {
      rangedWeapon.skill = skills[map['SKILL']] ?? await SkillFactory(attributes).get(map['SKILL']);
    } if (rangedWeapon.id != null) {
      rangedWeapon.qualities = await getQualities(map["ID"]);
    } if (map["QUALITIES"] != null) {
      rangedWeapon.qualities.addAll([for (map in map["QUALITIES"]) await ItemQualityFactory().create(map)]);
    }
    return rangedWeapon;
  }

  @override
  Map<String, dynamic> toMap(RangedWeapon object) {
    return {
      "ID": object.id,
      "NAME": object.name,
      "WEAPON_RANGE": object.range,
      "RANGE_ATTRIBUTE": object.rangeAttribute?.id,
      "DAMAGE": object.damage,
      "DAMAGE_ATTRIBUTE": object.damageAttribute?.id,
      "SKILL": object.skill?.id,
      "AMMUNITION": object.ammunition,
      "QUALITIES": [for (ItemQuality quality in object.qualities.where((e) => e.mapNeeded)) ItemQualityFactory().toMap(quality)]
    };
  }
}
