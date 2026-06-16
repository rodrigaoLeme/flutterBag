import '../../../domain/usecases/advance_to_step_five/params.dart';
import '../../../domain/usecases/advance_to_step_five/repository.dart';
import '../../../domain/usecases/advance_to_step_five/result_typedef.dart';
import 'datasource.dart';

class RepositoryImpl implements Repository {
  final Datasource _datasource;
  const RepositoryImpl(this._datasource);

  @override
  Result call(Params params) => _datasource(params);
}
