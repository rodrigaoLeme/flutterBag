import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'core/endpoints/endpoints.dart';
import 'core/endpoints/endpoints_v2_dev.dart';
import 'core/services/http_client/base/http_client.dart';
import 'core/services/http_client/dio/dio_http_client.dart';
import 'core/services/refresh_token_client/dio/refresh_token_dio_client.dart';
import 'core/services/storage/hive/global_hive_initializer.dart';
import 'core/services/storage/hive/hive_storage_impl.dart';
import 'core/services/storage/interface.dart';
import 'core/services/storage/storage_type.dart';
import 'core/stores/proxies/auth/auth_proxy_store.dart';
import 'core/stores/proxies/token/token_proxy_store.dart';
import 'core/stores/proxies/user/home_user_proxy_store.dart';
import 'core/stores/session/domain/refresh_token_usecase_impl.dart';
import 'core/stores/session/external/api_v2/mapper.dart';
import 'core/stores/session/external/api_v2/refresh_token_datasource.dart';
import 'core/stores/session/presenter/session_store.dart';
import 'modules/auth/presenter/auth_module.dart';
import 'modules/design_system/design_system_page.dart';
import 'modules/home/presenter/home_module.dart';
import 'modules/home/presenter/widgets/document_result.dart';
import 'modules/splash/splash_page.dart';

class AppModule extends Module {
  @override
  final List<Bind> binds = [
    Bind<HttpClient>((i) => DioHttpClient(i(), i())),

    //Token (Session Store Facade) (For token refreshing)
    Bind((i) => TokenProxyStore(i())),

    //Auth (Session Store Facade) (After logging, store new LoggedUser)
    Bind((i) => AuthProxyStore(i())),

    //HomeUser (Session Store Facade) (For Home page's features)
    Bind((i) => HomeUserProxyStore(i())),

    //Session
    Bind<SessionStore>((i) => SessionStore(i(), i()),
        onDispose: (value) => value.destroy()),
    Bind((i) => RefreshTokenUsecaseImpl(i())),
    Bind((i) => RefreshTokenV2Datasource(i(), i(), i())),
    Bind((i) => RefreshTokenV2Mapper()),
    Bind((i) => RefreshTokenDioClient()),

    //Storaging
    Bind<Storage>((i) => HiveBoxStorage<String>(i(), StorageType.token)),
    Bind.singleton((i) => GlobalHiveInitializer()),

    //External connection
    Bind<Endpoints>((i) => EndpointsV2Dev()),
    Bind((i) => Dio()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute, child: (_, __) => const SplashPage()),
    ModuleRoute('/auth', module: AuthModule()),
    ChildRoute('/ds', child: (context, args) => const DesignSystemPage()),
    ModuleRoute('/home', module: HomeModule()),
    ChildRoute('/document/result',
        child: (context, args) => const DocumentsResult()),
  ];
}
