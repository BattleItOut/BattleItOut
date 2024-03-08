
import 'package:battle_it_out/persistence/item/item.dart';
import 'package:battle_it_out/providers/item/abstract_item_provider.dart';

class ItemRepository extends AbstractItemRepository<Item> {
  @override
  get tableName => "items";
  @override
  get qualitiesTableName => "items_qualities";
  @override
  // TODO: implement linkTableName
  get linkTableName => throw UnimplementedError();

  @override
  Future<Item> fromDatabase(Map<String, dynamic> map) async {
    return Item(
        id: map["ID"],
        name: map["NAME"],
        cost: map["COST"],
        encumbrance: map["ENCUMBRANCE"],
        availability: map["AVAILABILITY"],
        category: map["CATEGORY"]);
  }

  @override
  Future<Map<String, dynamic>> toDatabase(Item object) async {
    // TODO: implement toMap
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> toMap(Item object, {optimised = true, database = false}) async {
    // TODO: implement toMap
    throw UnimplementedError();
  }
}
