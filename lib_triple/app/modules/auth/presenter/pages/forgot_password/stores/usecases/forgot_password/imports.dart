import 'package:flutter_modular/flutter_modular.dart';

import '../../../../../../domain/usecases/forgot_password/usecase_impl.dart';
import '../../../../../../external/datasources/forgot_password/datasource_impl_v2.dart';
import '../../../../../../external/datasources/forgot_password/mapper.dart';
import '../../../../../../infra/repositories/forgot_password/repository_impl.dart';
import 'store.dart';

final imports = <Bind>[
  Bind<Store>((i) => Store(i()), onDispose: (value) => value.destroy()),
  Bind((i) => UsecaseImpl(i())),
  Bind((i) => RepositoryImpl(i())),
  Bind((i) => DatasourceImplV2(i(), i(), i())),
  Bind((i) => const Mapper()),
];
