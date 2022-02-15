import 'package:battle_it_out/persistence/dao/dao.dart';
import 'package:battle_it_out/persistence/dao/item_quality_dao.dart';
import 'package:battle_it_out/persistence/dao/skill_dao.dart';
import 'package:battle_it_out/persistence/entities/attribute.dart';
import 'package:battle_it_out/persistence/entities/item_quality.dart';
import 'package:battle_it_out/persistence/entities/melee_weapon.dart';
import 'package:battle_it_out/persistence/entities/skill.dart';
import 'package:battle_it_out/persistence/wfrp_database.dart';

class MeleeWeaponDAO extends DAO<MeleeWeapon> {
  Map<int, Skill> skills;
  Map<int, Attribute> attributes;

  MeleeWeaponDAO(this.attributes, this.skills);

  @override
  get tableName => 'weapons_melee';

  Future<List<ItemQuality>> getQualities(WFRPDatabase database, int id) async {
    final List<Map<String, dynamic>> map =
        await database.database!.query("weapons_melee_qualities", where: "WEAPON_ID = ?", whereArgs: [id]);
    List<ItemQuality> qualities = [];
    for (int i = 0; i < map.length; i++) {
      qualities.add(await ItemQualityDAO().get(database, map[i]["QUALITY_ID"]));
    }
    return qualities;
  }

  @override
  Future<MeleeWeapon> fromMap(Map<String, dynamic> map, WFRPDatabase database) async {
    return MeleeWeapon(
        id: map["ID"],
        name: map["NAME"],
        length: map["LENGTH"],
        damage: map["DAMAGE"],
        skill: skills[map['SKILL']] ?? await SkillDAO(attributes).get(database, map['SKILL']),
        qualities: await getQualities(database, map["ID"]));
  }
}
