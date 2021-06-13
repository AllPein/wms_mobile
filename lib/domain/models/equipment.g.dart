// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'equipment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Equipment _$EquipmentFromJson(Map<String, dynamic> json) {
  return Equipment(
    id: json['id'] as String,
    name: json['name'] as String,
    items: (json['items'] as List<dynamic>)
        .map((e) => Item.fromJson(e as Map<String, dynamic>))
        .toList(),
    pavilion: Pavilion.fromJson(json['pavilion'] as Map<String, dynamic>),
    code: json['code'] as String,
  );
}

Map<String, dynamic> _$EquipmentToJson(Equipment instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'items': instance.items,
      'pavilion': instance.pavilion,
      'code': instance.code,
    };

Pavilion _$PavilionFromJson(Map<String, dynamic> json) {
  return Pavilion(
    id: json['id'] as String,
    address: json['address'] as String,
    code: json['code'] as String,
  );
}

Map<String, dynamic> _$PavilionToJson(Pavilion instance) => <String, dynamic>{
      'id': instance.id,
      'address': instance.address,
      'code': instance.code,
    };
