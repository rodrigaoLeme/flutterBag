import '../../../domain/usecases/advance_to_step_five/params.dart';
import '../../../domain/usecases/advance_to_step_five/result_typedef.dart';

abstract class Datasource {
  Result call(Params params);
  const Datasource();
}
