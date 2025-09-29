import '../../../domain/usecases/finish_sending_documents/params.dart';
import '../../../domain/usecases/finish_sending_documents/repository.dart';
import '../../../domain/usecases/finish_sending_documents/result_typedef.dart';
import 'datasource.dart';

class RepositoryImpl implements Repository {
  final Datasource _datasource;

  const RepositoryImpl(this._datasource);

  @override
  Result call(Params params) => _datasource(params);
}
