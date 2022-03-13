import 'package:battle_it_out/persistence/dao/dao.dart';
import 'package:battle_it_out/persistence/entities/attribute.dart';
import 'package:battle_it_out/persistence/entities/skill.dart';

class SkillDAO extends DAO<Skill> {
  Map<int, Attribute> attributes;

  SkillDAO(this.attributes);

  @override
  get tableName => 'skills';

  getBasicSkills() async {
    List<Skill> basicSkills = await getAll(where: "ADV == ? AND GROUPED == ?", whereArgs: [0, 0]);
    return basicSkills.where((skill) => skill.getSpecialityName() == null);
  }

  @override
  Skill fromMap(Map<String, dynamic> map, [Map overrideMap = const {}]) {
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
