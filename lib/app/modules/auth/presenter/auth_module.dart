import 'package:flutter_modular/flutter_modular.dart';

import '../domain/usecases/login_with_id/login_with_id_usecase_impl.dart';
import '../external/datasources/login_with_id/api_v2/datasource_impl_v2.dart';
import '../external/datasources/login_with_id/api_v2/mapper.dart';
import '../infra/repositories/login_with_id/repository_impl.dart';
import 'login_with_id_page.dart';
import 'pages/forgot_password/forgot_password_page.dart';
import 'store/login_with_id_store.dart';
import 'pages/forgot_password/stores/usecases/forgot_password/imports.dart' as forgot_password;

class AuthModule extends Module {
  @override
  final List<Bind> binds = [
    Bind<LoginWithIdStore>(
      (i) => LoginWithIdStore(i(), i()),
      onDispose: (value) => value.destroy(),
    ),
    Bind((i) => LoginWithIdUsecaseImpl(i())),
    Bind((i) => LoginWithIdRepositoryImpl(i())),
    Bind((i) => LoginWithIdDatasourceImplV2(i(), i(), i())),
    Bind((i) => LoginWithIdDatasourceMapperV2()),
    ...forgot_password.imports
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: ((context, args) => const LoginWithIdPage())),
    ChildRoute('/forgot_password', child: ((context, args) => const ForgotPasswordPage()))
  ];
}
