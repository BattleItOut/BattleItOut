import 'package:battle_it_out/persistence/dao/dao.dart';
import 'package:battle_it_out/persistence/entities/attribute.dart';
import 'package:battle_it_out/persistence/entities/talent.dart';
import 'package:battle_it_out/persistence/wfrp_database.dart';

class TalentDAO extends DAO<Talent> {
  Map<int, Attribute> attributes;

  TalentDAO(this.attributes);

  @override
  get tableName => 'talents';

  @override
  Talent fromMap(Map<String, dynamic> map, WFRPDatabase database) {
    return Talent(
        id: map[0]['ID'],
        name: map[0]['NAME'],
        nameEng: map[0]['NAME_ENG'],
        maxLvl: attributes[map[0]["MAX_LVL"]],
        constLvl: map[0]['CONST_LVL'],
        description: map[0]['DESCR'],
        grouped: map[0]['GROUPED'] == 1);
  }
}
