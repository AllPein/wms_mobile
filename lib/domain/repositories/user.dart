import 'dart:convert';

import 'package:wms_mobile/domain/models/user.dart';
import 'package:wms_mobile/domain/repositories/base_repository.dart';

class UserRepository extends BaseRepository {
  Future<User?> getUser() async {
    print('getting user');
    try {
      final res = await api.client.get(Uri.parse(api.baseUrl + '/user'));
      final data = jsonDecode(res.body);
      return User.fromJson(data);
    } catch (err) {
      print('huy');
      print(err);
    }
  }
}
