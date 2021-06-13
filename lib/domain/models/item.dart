import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart' show Color, Colors;
import 'package:json_annotation/json_annotation.dart';

part 'item.g.dart';

@JsonSerializable(includeIfNull: false)
class Item extends Equatable {
  final String? id;
  final String name;
  final String supplyCode;
  final DateTime? departureAt;
  final DateTime expiresAt;
  final String? equipmentId;
  final String? cellId;
  final double price;
  final String country;
  final ItemStatus? status;

  static Item empty = Item(
      name: '',
      supplyCode: '',
      country: '',
      price: 0,
      expiresAt: DateTime.now(),
      status: ItemStatus.INSTOCK);

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);

  Item(
      {this.id,
      required this.name,
      required this.country,
      required this.supplyCode,
      this.departureAt,
      required this.expiresAt,
      this.equipmentId,
      this.cellId,
      required this.price,
      this.status});
  Map<String, dynamic> toJson() => _$ItemToJson(this);

  Item copyWith(
      {String? id,
      String? name,
      String? supplyCode,
      DateTime? departureAt,
      DateTime? expiresAt,
      String? equipmentId,
      String? cellId,
      double? price,
      String? country,
      ItemStatus? status}) {
    return Item(
        id: id ?? this.id,
        name: name ?? this.name,
        supplyCode: supplyCode ?? this.supplyCode,
        departureAt: departureAt ?? this.departureAt,
        expiresAt: expiresAt ?? this.expiresAt,
        equipmentId: equipmentId ?? this.equipmentId,
        cellId: cellId ?? this.cellId,
        price: price ?? this.price,
        country: country ?? this.country,
        status: status ?? this.status);
  }

  @override
  List<Object?> get props => [id, name, supplyCode, price, country, status];
}

enum ItemStatus { INSTOCK, SENT }

final mapStatusToText = <ItemStatus, String>{
  ItemStatus.SENT: 'Отправлен',
  ItemStatus.INSTOCK: 'На складе',
  // ItemStatus.ALLOCATION: 'Размещение',
  // ItemStatus.UNLOADING: 'Разгрузка'
};

final mapStatusToColor = <ItemStatus, Color>{
  ItemStatus.SENT: Colors.redAccent,
  ItemStatus.INSTOCK: Colors.greenAccent,
  // ItemStatus.ALLOCATION: Colors.deepOrange,
  // ItemStatus.UNLOADING: Color(0xFFF4C430)
};
