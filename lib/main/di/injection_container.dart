import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

import '../../data/cache/cache.dart';
import '../../infra/cache/storage_adapters.dart';
import '../../infra/http/dio_adapter.dart';
import '../decorators/authorize_http_client_decorator.dart';
import '../flavors.dart';

final sl = GetIt.instance;

void setupInjection() {
  // ---------------------------------------------------------------------------
  // Storage — singletons: uma única instância compartilhada por todo o app
  // ---------------------------------------------------------------------------
  sl.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );

  sl.registerLazySingleton<SecureStorage>(
    () => FlutterSecureStorageAdapter(sl<FlutterSecureStorage>()),
  );

  sl.registerLazySingleton<LocalStorage>(
    () => JsonFileStorageAdapter(),
  );

  // ---------------------------------------------------------------------------
  // HTTP — singletons: Dio e adaptadores criados uma única vez
  // ---------------------------------------------------------------------------
  sl.registerLazySingleton<Dio>(
    () => Dio(BaseOptions(baseUrl: Flavor.apiBaseUrl)),
  );

  // Cliente HTTP simples — usado em endpoints públicos (login, cadastro…)
  sl.registerLazySingleton<DioAdapter>(
    () => DioAdapter(sl<Dio>()),
  );

  // Cliente HTTP autenticado — injeta Bearer token e lida com refresh automático
  sl.registerLazySingleton<AuthorizeHttpClientDecorator>(
    () => AuthorizeHttpClientDecorator(
      decoratee: sl<DioAdapter>(),
      secureStorage: sl<SecureStorage>(),
    ),
  );
}
