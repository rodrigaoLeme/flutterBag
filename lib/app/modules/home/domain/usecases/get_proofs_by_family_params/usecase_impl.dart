import 'params.dart';
import 'repository.dart';
import 'result_typedef.dart';
import 'usecase.dart';

class UsecaseImpl implements Usecase {
  final Repository _repository;

  const UsecaseImpl(this._repository);

  @override
  Result call(Params params) => _repository(params);
}
