import 'package:battle_it_out/persistence/dao/dao.dart';
import 'package:battle_it_out/persistence/entities/attribute.dart';
import 'package:battle_it_out/persistence/wfrp_database.dart';

class AttributeDAO extends DAO<Attribute> {
  @override
  get tableName => 'attributes';

  @override
  Attribute fromMap(Map<String, dynamic> map) {
    return Attribute(id: map['ID'], name: map['NAME'], rollable: map['ROLLABLE'], importance: map['IMPORTANCE']);
  }
}
