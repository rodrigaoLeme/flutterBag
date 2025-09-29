import 'package:flutter_modular/flutter_modular.dart';

import '../../domain/usecases/get_scholarship_by_period/usecase_impl.dart';
import '../../external/usecases/get_scholarship_by_period/mapper.dart';
import '../../external/usecases/get_scholarship_by_period/datasource_impl_v2.dart';
import '../../infra/usecases/get_scholarship_by_period/repository_impl.dart';
import '../stores/usecases/get_scholarship_by_period/store.dart';

final getScholarshipByPeriodUsecaseBinds = <Bind>[
  Bind<Store>((i) => Store(i()), onDispose: (value) => value.destroy()),
  Bind((i) => UsecaseImpl(i())),
  Bind((i) => RepositoryImpl(i())),
  Bind((i) => DatasourceImplV2(i(), i(), i())),
  Bind((i) => const Mapper()),
];
