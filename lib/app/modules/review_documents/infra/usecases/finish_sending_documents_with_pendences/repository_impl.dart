import '../../../domain/usecases/finish_sending_documents_with_pendences/params.dart';
import '../../../domain/usecases/finish_sending_documents_with_pendences/repository.dart';
import '../../../domain/usecases/finish_sending_documents_with_pendences/result_typedef.dart';
import 'datasource.dart';

class RepositoryImpl implements Repository {
  final Datasource _datasource;

  const RepositoryImpl(this._datasource);

  @override
  Result call(Params params) => _datasource(params);
}
