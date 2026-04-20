import 'package:flutter_modular/flutter_modular.dart';

import '../../domain/usecases/get_authorized_especial_users/usecase_impl.dart';
import '../../external/usecases/get_authorized_especial_users/datasource_impl_v2.dart';
import '../../external/usecases/get_authorized_especial_users/mapper.dart';
import '../../infra/usecases/get_authorized_especial_users/repository_impl.dart';
import '../stores/usecases/get_authorized_especial_users/store.dart';

final getAuthorizedEspecialUserUsecaseBinds = <Bind>[
  Bind<Store>((i) => Store(i()), onDispose: (value) => value.destroy()),
  Bind((i) => UsecaseImpl(i())),
  Bind((i) => RepositoryImpl(i())),
  Bind((i) => DatasourceImplV2(i(), i(), i())),
  Bind((i) => const Mapper()),
];
