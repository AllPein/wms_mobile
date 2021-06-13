// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Item _$ItemFromJson(Map<String, dynamic> json) {
  return Item(
    id: json['id'] as String?,
    name: json['name'] as String,
    country: json['country'] as String,
    supplyCode: json['supplyCode'] as String,
    departureAt: json['departureAt'] == null
        ? null
        : DateTime.parse(json['departureAt'] as String),
    expiresAt: DateTime.parse(json['expiresAt'] as String),
    equipmentId: json['equipmentId'] as String?,
    cellId: json['cellId'] as String?,
    price: (json['price'] as num).toDouble(),
    status: _$enumDecodeNullable(_$ItemStatusEnumMap, json['status']),
  );
}

Map<String, dynamic> _$ItemToJson(Item instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['name'] = instance.name;
  val['supplyCode'] = instance.supplyCode;
  writeNotNull('departureAt', instance.departureAt?.toIso8601String());
  val['expiresAt'] = instance.expiresAt.toIso8601String();
  writeNotNull('equipmentId', instance.equipmentId);
  writeNotNull('cellId', instance.cellId);
  val['price'] = instance.price;
  val['country'] = instance.country;
  writeNotNull('status', _$ItemStatusEnumMap[instance.status]);
  return val;
}

K _$enumDecode<K, V>(
  Map<K, V> enumValues,
  Object? source, {
  K? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  return enumValues.entries.singleWhere(
    (e) => e.value == source,
    orElse: () {
      if (unknownValue == null) {
        throw ArgumentError(
          '`$source` is not one of the supported values: '
          '${enumValues.values.join(', ')}',
        );
      }
      return MapEntry(unknownValue, enumValues.values.first);
    },
  ).key;
}

K? _$enumDecodeNullable<K, V>(
  Map<K, V> enumValues,
  dynamic source, {
  K? unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<K, V>(enumValues, source, unknownValue: unknownValue);
}

const _$ItemStatusEnumMap = {
  ItemStatus.INSTOCK: 'INSTOCK',
  ItemStatus.SENT: 'SENT',
};
