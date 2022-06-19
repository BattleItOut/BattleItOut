import 'package:battle_it_out/persistence/dao/dao.dart';
import 'package:battle_it_out/persistence/entities/npc_trait.dart';

class NPCTraitDAO extends DAO<Trait> {
  @override
  get tableName => 'npc_traits';

  @override
  fromMap(Map<String, dynamic> map, [Map overrideMap = const {}]) {
    return Trait(id: map["ID"], name: map["NAME"], description: map["DESCRIPTION"]);
  }
}
