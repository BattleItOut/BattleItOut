import 'package:battle_it_out/persistence/dao/item_dao.dart';
import 'package:battle_it_out/persistence/dao/item_quality_dao.dart';
import 'package:battle_it_out/persistence/dao/length_dao.dart';
import 'package:battle_it_out/persistence/dao/skill_dao.dart';
import 'package:battle_it_out/persistence/entities/attribute.dart';
import 'package:battle_it_out/persistence/entities/item_quality.dart';
import 'package:battle_it_out/persistence/entities/melee_weapon.dart';
import 'package:battle_it_out/persistence/entities/skill.dart';

class MeleeWeaponFactory extends ItemFactory<MeleeWeapon> {
  Map<int, Skill>? skills;
  Map<int, Attribute>? attributes;

  MeleeWeaponFactory([this.attributes, this.skills]);

  @override
  get tableName => 'weapons_melee';
  @override
  get qualitiesTableName => 'weapons_melee_qualities';

  @override
  Future<MeleeWeapon> fromMap(Map<String, dynamic> map, [Map overrideMap = const {}]) async {
    MeleeWeapon meleeWeapon = MeleeWeapon(
        id: map["ID"],
        name: map["NAME"],
        length: await WeaponLengthFactory().get(map["LENGTH"]),
        damage: map["DAMAGE"],
        twoHanded: map["TWO_HANDED"] == 1,
        itemCategory: map["ITEM_CATEGORY"],
        damageAttribute: attributes?[map["ITEM_CATEGORY"] ?? 3]);
    if (map["SKILL"] != null) {
      meleeWeapon.skill = skills?[map['SKILL']] ?? await SkillFactory(attributes).get(map['SKILL']);
    } if (meleeWeapon.id != null) {
      meleeWeapon.qualities = await getQualities(map["ID"]);
    } if (map["QUALITIES"] != null) {
      meleeWeapon.qualities.addAll([for (map in map["QUALITIES"]) await ItemQualityFactory().create(map)]);
    }
    return meleeWeapon;
  }

  @override
  Future<Map<String, dynamic>> toMap(MeleeWeapon object, [optimised = true]) async {
      Map<String, dynamic> map = {
        "ID": object.id,
        "NAME": object.name,
        "LENGTH": object.length.id,
        "DAMAGE": object.damage,
        "SKILL": object.skill?.id,
        "DAMAGE_ATTRIBUTE": object.damageAttribute?.id,
        "ITEM_CATEGORY": object.category,
        "QUALITIES": [for (ItemQuality quality in object.qualities.where((e) => e.mapNeeded)) await ItemQualityFactory().toMap(quality)]
      };
      if (optimised) {
        map = await optimise(map);
        if (object.qualities.isEmpty) {
          map.remove("QUALITIES");
        }
      }
      return map;
  }
}
