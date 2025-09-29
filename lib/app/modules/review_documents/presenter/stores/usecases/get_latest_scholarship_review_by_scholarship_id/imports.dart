import 'package:flutter_modular/flutter_modular.dart';

import '../../../../domain/usecases/get_latest_scholarship_review_by_scholarship_id/usecase_impl.dart';
import '../../../../external/usecases/get_latest_scholarship_review_by_scholarship_id/datasource_impl_v2.dart';
import '../../../../external/usecases/get_latest_scholarship_review_by_scholarship_id/mapper.dart';
import '../../../../infra/usecases/get_latest_scholarship_review_by_scholarship_id/repository_impl.dart';
import 'store.dart';

final imports = <Bind>[
  Bind<Store>((i) => Store(i()), onDispose: (value) => value.destroy()),
  Bind((i) => UsecaseImpl(i())),
  Bind((i) => RepositoryImpl(i())),
  Bind((i) => DatasourceImplV2(i(), i(), i())),
  Bind((i) => const Mapper()),
];
