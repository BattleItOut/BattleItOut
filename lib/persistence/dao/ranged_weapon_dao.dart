import 'package:battle_it_out/persistence/dao/item_dao.dart';
import 'package:battle_it_out/persistence/dao/skill_dao.dart';
import 'package:battle_it_out/persistence/entities/attribute.dart';
import 'package:battle_it_out/persistence/entities/ranged_weapon.dart';
import 'package:battle_it_out/persistence/entities/skill.dart';

class RangedWeaponDTO extends ItemDAO {
  Map<int, Skill> skills;
  Map<int, Attribute> attributes;

  RangedWeaponDTO(this.attributes, this.skills);

  @override
  get tableName => 'weapons_ranged';
  @override
  get qualitiesTableName => 'weapons_melee_qualities';

  @override
  Future<RangedWeapon> fromMap(Map<String, dynamic> map) async {
    return RangedWeapon(
        id: map["ID"],
        name: map["NAME"],
        range: map["WEAPON_RANGE"],
        damage: map["DAMAGE"],
        strengthBonus: map["STRENGTH_BONUS"] == 1,
        skill: skills[map['SKILL']] ?? await SkillDAO(attributes).get(map['SKILL']),
        qualities: await getQualities(map["ID"]));
  }
}
