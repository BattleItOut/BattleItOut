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
        id: map['ID'],
        name: map['NAME'],
        nameEng: map['NAME_ENG'],
        maxLvl: attributes[map["MAX_LVL"]],
        constLvl: map['CONST_LVL'],
        description: map['DESCR'],
        grouped: map['GROUPED'] == 1);
  }
}
