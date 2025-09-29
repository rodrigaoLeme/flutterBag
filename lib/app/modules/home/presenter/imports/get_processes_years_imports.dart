import 'package:flutter_modular/flutter_modular.dart';

import '../../domain/usecases/get_processes_years/usecase_impl.dart';
import '../../external/usecases/get_processes_years/mapper.dart';
import '../../external/usecases/get_processes_years/datasource_impl_v2.dart';
import '../../infra/usecases/get_processes_years/repository_impl.dart';
import '../stores/usecases/get_processes_years/store.dart';

final getProcessesYearsUsecaseBinds = <Bind>[
  Bind<Store>((i) => Store(i()), onDispose: (value) => value.destroy()),
  Bind((i) => UsecaseImpl(i())),
  Bind((i) => RepositoryImpl(i())),
  Bind((i) => DatasourceImplV2(i(), i(), i())),
  Bind((i) => const Mapper()),
];
