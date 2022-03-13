import 'package:battle_it_out/persistence/dao/dao.dart';
import 'package:battle_it_out/persistence/entities/attribute.dart';
import 'package:battle_it_out/persistence/entities/talent.dart';

class TalentDAO extends DAO<Talent> {
  Map<int, Attribute>? attributes;

  TalentDAO([this.attributes]);

  @override
  get tableName => 'talents';

  @override
  Future<Talent> fromMap(Map<String, dynamic> map, [Map overrideMap = const {}]) async {
    BaseTalent? baseTalent = map["BASE_TALENT"] == null ? null : await BaseTalentDAO().get(map["BASE_TALENT"]);
    return Talent(
        id: map['ID'],
        name: map['NAME'],
        attribute: attributes?[map["MAX_LVL"]],
        constLvl: map['CONST_LVL'],
        baseTalent: baseTalent,
        grouped: map['GROUPED'] == 1);
  }
}

class BaseTalentDAO extends DAO<BaseTalent> {
  @override
  get tableName => 'talents_base';

  @override
  BaseTalent fromMap(Map<String, dynamic> map, [Map overrideMap = const {}]) {
    return BaseTalent(
        id: map['ID'],
        name: map['NAME'],
        description: map['DESCRIPTION'],
        source: map['SOURCE']);
  }
}

