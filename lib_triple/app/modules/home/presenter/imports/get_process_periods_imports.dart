import 'package:flutter_modular/flutter_modular.dart';

import '../../domain/usecases/get_process_periods/usecase_impl.dart';
import '../../external/usecases/get_process_periods/mapper.dart';
import '../../external/usecases/get_process_periods/datasource_impl_v2.dart';
import '../../infra/usecases/get_process_periods/repository_impl.dart';
import '../stores/usecases/get_process_periods/store.dart';

final getProcessPeriodsUsecaseBinds = <Bind>[
  Bind<Store>((i) => Store(i()), onDispose: (value) => value.destroy()),
  Bind((i) => UsecaseImpl(i())),
  Bind((i) => RepositoryImpl(i())),
  Bind((i) => DatasourceImplV2(i(), i(), i())),
  Bind((i) => const Mapper()),
];
