import 'package:flutter_modular/flutter_modular.dart';

import '../../domain/usecases/set_device_code/usecase_impl.dart';
import '../../external/usecases/set_device_code/datasource_impl_v2.dart';
import '../../external/usecases/set_device_code/mapper.dart';
import '../../infra/usecases/set_device_code/repository_impl.dart';
import '../stores/usecases/set_device_code/store.dart';

final setDeviceCodeBinds = <Bind>[
  Bind<Store>((i) => Store(i()), onDispose: (value) => value.destroy()),
  Bind((i) => UsecaseImpl(i())),
  Bind((i) => RepositoryImpl(i())),
  Bind((i) => DatasourceImplV2(i(), i(), i())),
  Bind((i) => const Mapper()),
];
