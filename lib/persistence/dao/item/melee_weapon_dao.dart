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
  get qualitiesTableName => 'item_qualities';
  @override
  get linkTableName => 'weapons_melee_qualities';

  @override
  Map<String, dynamic> get defaultValues => {"DAMAGE_ATTRIBUTE": 3, "ITEM_CATEGORY": "MELEE_WEAPONS"};

  @override
  Future<MeleeWeapon> fromMap(Map<String, dynamic> map) async {
    defaultValues.forEach((key, value) {
      map.putIfAbsent(key, () => value);
    });
    Attribute? damageAttribute = attributes?.firstWhere((attribute) => attribute.id == map["DAMAGE_ATTRIBUTE"]);
    MeleeWeapon meleeWeapon = MeleeWeapon(id: map["ID"] ?? await getNextId(),
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
        ItemQuality quality = await ItemQualityFactory().create(map);
        if (!meleeWeapon.qualities.contains(quality)) {
          meleeWeapon.qualities.add(quality);
        }
      }
    }
    return meleeWeapon;
  }

  @override
  Future<Map<String, dynamic>> toMap(MeleeWeapon object, {optimised = true, database = false}) async {
    Map<String, dynamic> map = {
      "ID": object.id,
      "NAME": object.name,
      "LENGTH": object.length.id,
      "DAMAGE": object.damage,
      "SKILL": object.skill?.id,
      "DAMAGE_ATTRIBUTE": object.damageAttribute?.id,
      "ITEM_CATEGORY": object.category,
    };
    if (!database) {
      map["QUALITIES"] = [
        for (ItemQuality quality in object.qualities.where((e) => e.mapNeeded)) await ItemQualityFactory().toMap(
            quality)
      ];
      if (optimised) {
        map = await optimise(map);
        if (object.qualities.isEmpty) {
          map.remove("QUALITIES");
        }
      }
    }
    return map;
  }
}
