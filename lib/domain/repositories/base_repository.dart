import 'package:get_it/get_it.dart';
import 'package:wms_mobile/domain/services/api.dart';

abstract class BaseRepository {
  final api = GetIt.I<Api>();

  AuthenticatedHttpClient get client => api.client;
}
