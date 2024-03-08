import 'package:battle_it_out/persistence/attribute.dart';
import 'package:battle_it_out/persistence/item/item_quality.dart';
import 'package:battle_it_out/persistence/item/melee_weapon.dart';
import 'package:battle_it_out/persistence/skill/skill.dart';
import 'package:battle_it_out/providers/item/abstract_item_provider.dart';
import 'package:battle_it_out/providers/item/item_quality_provider.dart';
import 'package:battle_it_out/providers/item/weapon_length_provider.dart';
import 'package:battle_it_out/providers/skill/skill_provider.dart';
import 'package:collection/collection.dart';

class MeleeWeaponRepository extends AbstractItemRepository<MeleeWeapon> {
  List<Skill>? skills;
  List<Attribute>? attributes;

  MeleeWeaponRepository([this.attributes, this.skills]);

  @override
  get tableName => 'weapons_melee';
  @override
  get linkTableName => 'weapons_melee_qualities';

  @override
  Map<String, dynamic> get defaultValues => {"DAMAGE_ATTRIBUTE": 3, "ITEM_CATEGORY": "MELEE_WEAPONS"};

  @override
  Future<MeleeWeapon> fromDatabase(Map<String, dynamic> map) async {
    defaultValues.forEach((key, value) {
      map.putIfAbsent(key, () => value);
    });
    Attribute? damageAttribute = attributes?.firstWhereOrNull((attribute) => attribute.id == map["DAMAGE_ATTRIBUTE"]);
    MeleeWeapon meleeWeapon = MeleeWeapon(
        id: map["ID"],
        name: map["NAME"],
        length: (await WeaponLengthRepository().get(map["LENGTH"]))!,
        damage: map["DAMAGE"],
        twoHanded: map["TWO_HANDED"] == 1,
        damageAttribute: damageAttribute);
    if (map["SKILL"] != null) {
      Skill? skill = skills?.firstWhereOrNull((element) => element.id == map['SKILL']);
      meleeWeapon.skill = skill ?? await SkillRepository().get(map['SKILL']);
    }
    if (map["ID"] != null) {
      meleeWeapon.qualities = await getQualities(map["ID"]);
    }
    if (map["QUALITIES"] != null) {
      for (Map<String, dynamic> map in map["QUALITIES"]) {
        ItemQuality quality = await ItemQualityRepository().create(map);
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

  @override
  Future<Map<String, dynamic>> toMap(MeleeWeapon object, {optimised = true}) async {
    Map<String, dynamic> map = {
      "ID": object.id,
      "NAME": object.name,
      "LENGTH": object.length.id,
      "DAMAGE": object.damage,
      "SKILL": object.skill?.id,
      "DAMAGE_ATTRIBUTE": object.damageAttribute?.id,
      "ITEM_CATEGORY": object.category,
      "QUALITIES": [for (ItemQuality quality in object.qualities) await ItemQualityRepository().toMap(quality)]
    };
    if (optimised) {
      map = await optimise(map);
    }
    return map;
  }
}
