import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:wms_mobile/constants.dart';
import 'package:wms_mobile/domain/services/storage.dart';
import 'package:http/http.dart' as http;

class ApiError implements Exception {}

class MissingCredentialsError implements Exception {}

class Api {
  late AuthenticatedHttpClient _client;
  final String baseUrl = 'https://industrialsystembackend.herokuapp.com/api/v1';
  final _storage = GetIt.I<Storage>();

  AuthenticatedHttpClient get client => _client;

  Api() {
    _client = AuthenticatedHttpClient();
  }
}

class AuthenticatedHttpClient extends http.BaseClient {
  final _storage = GetIt.I<Storage>();

  AuthenticatedHttpClient();

  // Use a memory cache to avoid local storage access in each call
  String _inMemoryToken = '';
  String get userAccessToken {
    // use in memory token if available
    if (_inMemoryToken.isNotEmpty) return _inMemoryToken;

    // otherwise load it from local storage
    _inMemoryToken = _loadTokenFromSharedPreference();

    return _inMemoryToken;
  }

  final _baseHeaders = {'Content-Type': 'application/json'};

  @override
  Future<http.Response> get(Uri url, {Map<String, String>? headers}) {
    return super.get(url, headers: _baseHeaders..addAll(headers ?? {}));
  }

  @override
  Future<http.Response> post(Uri url,
      {Map<String, String>? headers, Object? body, Encoding? encoding}) {
    return super.post(url,
        headers: _baseHeaders..addAll(headers ?? {}),
        body: jsonEncode(body ?? null));
  }

  @override
  Future<http.Response> put(Uri url,
      {Map<String, String>? headers, Object? body, Encoding? encoding}) {
    return super.put(url,
        headers: _baseHeaders..addAll(headers ?? {}),
        body: jsonEncode(body ?? null));
  }

  @override
  Future<http.Response> patch(Uri url,
      {Map<String, String>? headers, Object? body, Encoding? encoding}) {
    return super.patch(url,
        headers: _baseHeaders..addAll(headers ?? {}),
        body: jsonEncode(body ?? null));
  }

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    print(userAccessToken);
    if (userAccessToken.isNotEmpty) {
      request.headers
          .putIfAbsent('Authorization', () => 'Bearer $userAccessToken');
    }
    return request.send();
  }

  String _loadTokenFromSharedPreference() {
    final token = _storage.get(AUTH_SAVE_TOKEN);
    return token ?? '';
  }

  // Don't forget to reset the cache when logging out the user
  void reset() {
    _inMemoryToken = '';
  }
}
