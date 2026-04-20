import 'package:flutter_modular/flutter_modular.dart';

import '../../../../domain/usecases/get_family_members_with_pendences_by_scholarship/usecase_impl.dart';
import '../../../../external/usecases/get_family_members_with_pendences_by_scholarship/datasource_impl_v2.dart';
import '../../../../external/usecases/get_family_members_with_pendences_by_scholarship/mapper.dart';
import '../../../../infra/usecases/get_family_members_with_pendences_by_scholarship/repository_impl.dart';
import 'store.dart';

final imports = <Bind>[
  Bind<Store>((i) => Store(i()), onDispose: (value) => value.destroy()),
  Bind((i) => UsecaseImpl(i())),
  Bind((i) => RepositoryImpl(i())),
  Bind((i) => DatasourceImplV2(i(), i(), i())),
  Bind((i) => const Mapper()),
];
