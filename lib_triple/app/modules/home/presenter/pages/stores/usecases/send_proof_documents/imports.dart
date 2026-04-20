import 'package:flutter_modular/flutter_modular.dart';

import '../../../../../domain/usecases/send_proof_document/usecase_impl.dart';
import '../../../../../external/usecases/send_proof_document/datasource_impl_v2.dart';
import '../../../../../infra/usecases/send_proof_document/repository_impl.dart';
import 'store.dart';

final imports = <Bind>[
  Bind<Store>((i) => Store(i()), onDispose: (value) => value.destroy()),
  Bind((i) => UsecaseImpl(i())),
  Bind((i) => RepositoryImpl(i())),
  Bind((i) => DatasourceImplV2(i(), i())),
];
