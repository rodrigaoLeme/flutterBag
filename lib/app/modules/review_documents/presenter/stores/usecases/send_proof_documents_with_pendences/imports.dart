import 'package:flutter_modular/flutter_modular.dart';
import '../../../../domain/usecases/send_proof_document_with_pendences/usecase_impl.dart';
import '../../../../infra/usecases/send_proof_document_with_pendences/repository_impl.dart';
import '../../../../external/usecases/send_proof_document_with_pendences/datasource_impl_v2.dart';

import 'store.dart';

final imports = <Bind>[
  Bind<Store>((i) => Store(i()), onDispose: (value) => value.destroy()),
  Bind((i) => UsecaseImpl(i())),
  Bind((i) => RepositoryImpl(i())),
  Bind((i) => DatasourceImplV2(i(), i())),
];
