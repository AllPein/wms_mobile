import 'package:json_annotation/json_annotation.dart';

import 'item.dart';

part 'equipment.g.dart';

@JsonSerializable()
class Equipment {
  final String id;
  final String name;
  final List<Item> items;
  final Pavilion pavilion;

  final String code;
  Equipment(
      {required this.id,
      required this.name,
      required this.items,
      required this.pavilion,
      required this.code});

  factory Equipment.fromJson(Map<String, dynamic> json) =>
      _$EquipmentFromJson(json);
}

@JsonSerializable()
class Pavilion {
  final String id;
  final String address;
  final String code;

  Pavilion({required this.id, required this.address, required this.code});

  factory Pavilion.fromJson(Map<String, dynamic> json) =>
      _$PavilionFromJson(json);
}
