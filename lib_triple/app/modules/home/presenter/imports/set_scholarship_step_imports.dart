import 'package:flutter_modular/flutter_modular.dart';

import '../../domain/usecases/set_scholarship_step/usecase_impl.dart';
import '../../external/usecases/set_scholarship_step/datasource_impl_v2.dart';
import '../../infra/usecases/set_scholarship_step/repository_impl.dart';
import '../pages/acceptance_terms/stores/usecases/set_scholarship_step/store.dart';

final setScholarshipStepUsecaseBinds = <Bind>[
  Bind<Store>((i) => Store(i()), onDispose: (value) => value.destroy()),
  Bind((i) => UsecaseImpl(i())),
  Bind((i) => RepositoryImpl(i())),
  Bind((i) => DatasourceImplV2(i(), i())),
];
