import 'package:flutter_modular/flutter_modular.dart';

import '../../domain/usecases/finish_sending_documents/usecase_impl.dart';
import '../../external/usecases/finish_sending_documents/datasource_impl_v2.dart';
import '../../infra/usecases/finish_sending_documents/repository_impl.dart';
import '../pages/select_group/stores/usecases/finish_sending_documents/store.dart';

final finishSendingDocumentsUsecaseBinds = <Bind>[
  Bind<Store>((i) => Store(i()), onDispose: (value) => value.destroy()),
  Bind((i) => UsecaseImpl(i())),
  Bind((i) => RepositoryImpl(i())),
  Bind((i) => DatasourceImplV2(i(), i())),
  //Bind((i) => const DatasourceImplV2Mock()),
];
