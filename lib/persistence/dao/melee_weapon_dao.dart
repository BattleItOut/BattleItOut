import 'package:battle_it_out/persistence/dao/item_dao.dart';
import 'package:battle_it_out/persistence/dao/length_dao.dart';
import 'package:battle_it_out/persistence/dao/skill_dao.dart';
import 'package:battle_it_out/persistence/entities/attribute.dart';
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
    return MeleeWeapon(
        id: map["ID"],
        name: map["NAME"],
        length: await WeaponLengthFactory().get(map["LENGTH"]),
        damage: map["DAMAGE"],
        damageAttribute: attributes?[map["DAMAGE_ATTRIBUTE"]],
        skill: skills?[map['SKILL']] ?? await SkillFactory(attributes).get(map['SKILL']),
        qualities: await getQualities(map["ID"]));
  }

  @override
  Map<String, dynamic> toMap(MeleeWeapon object) {
    // TODO: implement toMap
    throw UnimplementedError();
  }
}
