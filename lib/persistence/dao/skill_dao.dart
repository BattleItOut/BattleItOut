import 'package:battle_it_out/persistence/dao/dao.dart';
import 'package:battle_it_out/persistence/entities/attribute.dart';
import 'package:battle_it_out/persistence/entities/skill.dart';
import 'package:battle_it_out/persistence/wfrp_database.dart';

class SkillDAO extends DAO<Skill> {
  Map<int, Attribute> attributes;

  SkillDAO(this.attributes);

  @override
  get tableName => 'skills';

  @override
  Skill fromMap(Map<String, dynamic> map, WFRPDatabase database) {
    return Skill(
        id: map["ID"],
        name: map["NAME"],
        attribute: attributes[map["ATTR_ID"]],
        description: map["DESCR"],
        advanced: map["ADV"] == 1,
        grouped: map["GROUPED"] == 1,
        category: map["CATEGORY"]);
  }
}
