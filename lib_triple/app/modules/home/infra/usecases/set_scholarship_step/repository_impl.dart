import '../../../domain/usecases/set_scholarship_step/params.dart';
import '../../../domain/usecases/set_scholarship_step/repository.dart';
import '../../../domain/usecases/set_scholarship_step/result_typedef.dart';
import 'datasource.dart';

class RepositoryImpl implements Repository {
  final Datasource _datasource;
  const RepositoryImpl(this._datasource);

  @override
  Result call(Params params) => _datasource(params);
}
