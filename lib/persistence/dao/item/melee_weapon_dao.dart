import 'package:battle_it_out/persistence/dao/item/item_dao.dart';
import 'package:battle_it_out/persistence/dao/item/item_quality_dao.dart';
import 'package:battle_it_out/persistence/dao/item/length_dao.dart';
import 'package:battle_it_out/persistence/dao/skill_dao.dart';
import 'package:battle_it_out/persistence/entities/attribute.dart';
import 'package:battle_it_out/persistence/entities/item/item_quality.dart';
import 'package:battle_it_out/persistence/entities/item/melee_weapon.dart';
import 'package:battle_it_out/persistence/entities/skill.dart';

class MeleeWeaponFactory extends ItemFactory<MeleeWeapon> {
  List<Skill>? skills;
  List<Attribute>? attributes;

  MeleeWeaponFactory([this.attributes, this.skills]);

  @override
  get tableName => 'weapons_melee';
  @override
  get qualitiesTableName => 'weapons_melee_qualities';
  @override
  Map<String, dynamic> get defaultValues => {"DAMAGE_ATTRIBUTE": 3, "ITEM_CATEGORY": "MELEE_WEAPONS"};

  @override
  Future<MeleeWeapon> fromMap(Map<String, dynamic> map) async {
    defaultValues.forEach((key, value) {
      map.putIfAbsent(key, () => value);
    });
    Attribute? damageAttribute = attributes?.firstWhere((attribute) => attribute.id == map["DAMAGE_ATTRIBUTE"]);
    MeleeWeapon meleeWeapon = MeleeWeapon(
        databaseId: map["ID"],
        name: map["NAME"],
        length: await WeaponLengthFactory().get(map["LENGTH"]),
        damage: map["DAMAGE"],
        twoHanded: map["TWO_HANDED"] == 1,
        damageAttribute: damageAttribute);
    if (map["SKILL"] != null) {
      Skill? skill = skills?.firstWhere((element) => element.databaseId == map['SKILL']);
      meleeWeapon.skill = skill ?? await SkillFactory(attributes).get(map['SKILL']);
    }
    if (meleeWeapon.databaseId != null) {
      meleeWeapon.qualities = await getQualities(map["ID"]);
    }
    if (map["QUALITIES"] != null) {
      meleeWeapon.qualities.addAll([for (map in map["QUALITIES"]) await ItemQualityFactory().create(map)]);
    }
    return meleeWeapon;
  }

  @override
  Future<Map<String, dynamic>> toMap(MeleeWeapon object, [optimised = true]) async {
    Map<String, dynamic> map = {
      "ID": object.databaseId,
      "NAME": object.name,
      "LENGTH": object.length.id,
      "DAMAGE": object.damage,
      "SKILL": object.skill?.databaseId,
      "DAMAGE_ATTRIBUTE": object.damageAttribute?.id,
      "ITEM_CATEGORY": object.category,
      "QUALITIES": [
        for (ItemQuality quality in object.qualities.where((e) => e.mapNeeded))
          await ItemQualityFactory().toMap(quality)
      ]
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
