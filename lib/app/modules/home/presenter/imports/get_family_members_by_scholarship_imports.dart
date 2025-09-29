import 'package:flutter_modular/flutter_modular.dart';

import '../../domain/usecases/get_family_members_by_scholarship/usecase_impl.dart';
import '../../external/usecases/get_family_members_by_scholarship/mapper.dart';
import '../../external/usecases/get_family_members_by_scholarship/datasource_impl_v2.dart';
import '../../infra/usecases/get_family_members_by_scholarship/repository_impl.dart';
import '../pages/select_group/stores/usecases/get_family_members_by_scholarship/store.dart';

final getFamilyMembersByScholarshipUsecaseBinds = <Bind>[
  Bind<Store>((i) => Store(i()), onDispose: (value) => value.destroy()),
  Bind((i) => UsecaseImpl(i())),
  Bind((i) => RepositoryImpl(i())),
  Bind((i) => DatasourceImplV2(i(), i(), i())),
  Bind((i) => const Mapper()),
];
