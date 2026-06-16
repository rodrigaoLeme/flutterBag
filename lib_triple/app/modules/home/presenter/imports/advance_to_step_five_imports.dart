import 'package:flutter_modular/flutter_modular.dart';

import '../../domain/usecases/advance_to_step_five/usecase_impl.dart';
import '../../external/usecases/advance_to_step_five/datasource_impl_v2.dart';
import '../../infra/usecases/advance_to_step_five/repository_impl.dart';
import '../pages/acceptance_terms/stores/usecases/advance_to_step_five/store.dart';

final advanceToStepFiveUsecaseBinds = <Bind>[
  Bind<Store>((i) => Store(i()), onDispose: (value) => value.destroy()),
  Bind((i) => UsecaseImpl(i())),
  Bind((i) => RepositoryImpl(i())),
  Bind((i) => DatasourceImplV2(i(), i())),
];
