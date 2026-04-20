import 'params.dart';
import 'result_typedef.dart';

abstract class Repository {
  Result call(Params params);

  const Repository();
}
