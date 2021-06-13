import 'dart:convert';

import 'package:wms_mobile/domain/models/models.dart';
import 'package:wms_mobile/domain/repositories/base_repository.dart';

class HomeRepository extends BaseRepository {
  Future<List<Item>> fetchItems() async {
    final res = await client.get(Uri.parse(api.baseUrl + '/item'));
    final data = jsonDecode(res.body);
    return data.map((e) => Item.fromJson(e)).toList().cast<Item>();
  }

  Future<List<Equipment>> fetchEquipments() async {
    final res = await client.get(Uri.parse(api.baseUrl + '/equipment'));
    final data = jsonDecode(res.body);
    return data.map((e) => Equipment.fromJson(e)).toList().cast<Equipment>();
  }

  Future<List<Cell>> fetchCells() async {
    final res = await client.get(Uri.parse(api.baseUrl + '/cell'));
    final data = jsonDecode(res.body);
    return data.map((e) => Cell.fromJson(e)).toList().cast<Cell>();
  }

  Future<void> updateItem(Item item) async {
    await client.patch(Uri.parse(api.baseUrl + '/item'), body: [item.toJson()]);
    // final data = jsonDecode(res.body);
    // await client.patch('/item', data: [item.toJson()]);
  }

  Future<void> addItem(Item item) async {
    await client.post(Uri.parse(api.baseUrl + '/item'), body: item.toJson());
  }
}
