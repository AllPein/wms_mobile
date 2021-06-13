import 'dart:async';
import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:wms_mobile/constants.dart';
import 'package:wms_mobile/domain/models/user.dart';
import 'package:wms_mobile/domain/services/api.dart';
import 'package:wms_mobile/domain/services/storage.dart';

enum AuthenticationStatus { unknown, authenticated, unauthenticated }

class AuthenticationRepository {
  final _api = GetIt.I<Api>();
  final _storage = GetIt.I<Storage>();

  final _controller = StreamController<AuthenticationStatus>();

  Stream<AuthenticationStatus> get status async* {
    yield await _trySavedLogin();
    yield* _controller.stream;
  }

  Future<AuthenticationStatus> _trySavedLogin() async {
    final token = _storage.get(AUTH_SAVE_TOKEN);
    if (token != null) {
      return AuthenticationStatus.authenticated;
    }
    return AuthenticationStatus.unauthenticated;
  }

  Future<User?> logIn({
    required String username,
    required String password,
  }) async {
    final res = await _api.client.post(Uri.parse(_api.baseUrl + '/auth/login'),
        body: {'username': username, 'password': password});
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      final user = User.fromJson(data['user']);
      final token = data['token'];
      await _storage.save(AUTH_SAVE_TOKEN, token);
      _controller.add(AuthenticationStatus.authenticated);
      return user;
    }
  }

  void logOut() {
    _controller.add(AuthenticationStatus.unauthenticated);
  }

  void dispose() => _controller.close();
}
