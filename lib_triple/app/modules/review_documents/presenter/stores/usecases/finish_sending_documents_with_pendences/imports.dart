import 'package:flutter_modular/flutter_modular.dart';

import '../../../../domain/usecases/finish_sending_documents_with_pendences/usecase_impl.dart';
import '../../../../external/usecases/finish_sending_documents_with_pendences/datasource_impl_v2.dart';
import '../../../../infra/usecases/finish_sending_documents_with_pendences/repository_impl.dart';
import 'store.dart';

final imports = <Bind>[
  Bind<Store>((i) => Store(i())),
  Bind((i) => UsecaseImpl(i())),
  Bind((i) => RepositoryImpl(i())),
  Bind((i) => DatasourceImplV2(i(), i())),
];
