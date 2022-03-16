import 'package:battle_it_out/persistence/dao/item_dao.dart';
import 'package:battle_it_out/persistence/dao/length_dao.dart';
import 'package:battle_it_out/persistence/dao/skill_dao.dart';
import 'package:battle_it_out/persistence/entities/attribute.dart';
import 'package:battle_it_out/persistence/entities/melee_weapon.dart';
import 'package:battle_it_out/persistence/entities/skill.dart';

class MeleeWeaponDAO extends ItemDAO<MeleeWeapon> {
  Map<int, Skill>? skills;
  Map<int, Attribute>? attributes;

  MeleeWeaponDAO([this.attributes, this.skills]);

  @override
  get tableName => 'weapons_melee';
  @override
  get qualitiesTableName => 'weapons_melee_qualities';

  @override
  Future<MeleeWeapon> fromMap(Map<String, dynamic> map, [Map overrideMap = const {}]) async {
    return MeleeWeapon(
        id: map["ID"],
        name: map["NAME"],
        length: await WeaponLengthDAO().get(map["LENGTH"]),
        damage: map["DAMAGE"],
        damageAttribute: attributes?[map["DAMAGE_ATTRIBUTE"]],
        skill: skills?[map['SKILL']] ?? await SkillDAO(attributes).get(map['SKILL']),
        qualities: await getQualities(map["ID"]));
  }
}
