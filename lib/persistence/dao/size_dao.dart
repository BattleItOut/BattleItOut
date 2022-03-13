import 'package:battle_it_out/persistence/dao/dao.dart';
import 'package:battle_it_out/persistence/entities/size.dart';

class SizeDao extends DAO<Size> {
  @override
  get tableName => 'sizes';

  @override
  fromMap(Map<String, dynamic> map, [Map overrideMap = const {}]) {
    return Size(
        id: map["ID"],
        name: map["NAME"],
        source: map["SOURCE"]);
  }
}