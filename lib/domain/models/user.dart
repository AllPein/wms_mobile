import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final String id;
  final Role role;
  final String username;

  static const empty = User(id: '', role: Role.ADMIN, username: '');

  const User({required this.id, required this.role, required this.username});

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}

enum Role { ADMIN, EMPLOYEE, MANAGER }
