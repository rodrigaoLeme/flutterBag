import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

import '../../data/cache/cache.dart';
import '../../data/cache/enrollment_draft_storage.dart';
import '../../domain/usecases/auth/auth_usecases.dart';
import '../../infra/cache/storage_adapters.dart';
import '../../infra/http/dio_adapter.dart';
import '../../infra/repositories/auth/remote_load_account_usecase.dart';
import '../../share/current_account.dart';
import '../../share/session_events.dart';
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

  // Singleton de usuário logado
  sl.registerLazySingleton<CurrentAccount>(() => CurrentAccount());

  // Singleton de unauthorized request
  sl.registerLazySingleton<SessionEvents>(() => SessionEvents());

  // Usecase de carregar account - usa o cliente autenticado
  sl.registerLazySingleton<LoadAccountUsecase>(
    () => RemoteLoadAccountUsecase(
      httpClient: sl<AuthorizeHttpClientDecorator>(),
    ),
  );

  // Singleton dos Enrollment Storage
  sl.registerLazySingleton<EnrollmentDraftStorage>(
    () => EnrollmentDraftStorage(sl<LocalStorage>()),
  );
}
