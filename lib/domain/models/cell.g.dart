// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cell.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Cell _$CellFromJson(Map<String, dynamic> json) {
  return Cell(
    id: json['id'] as String,
    code: json['code'] as String,
    items: (json['items'] as List<dynamic>)
        .map((e) => Item.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$CellToJson(Cell instance) => <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'items': instance.items,
    };
