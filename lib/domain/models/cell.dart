import 'package:json_annotation/json_annotation.dart';

import 'item.dart';

part 'cell.g.dart';

@JsonSerializable()
class Cell {
  final String id;
  final String code;
  final List<Item> items;

  Cell({required this.id, required this.code, required this.items});

  factory Cell.fromJson(Map<String, dynamic> json) => _$CellFromJson(json);
}
