import '../../../domain/usecases/set_scholarship_step/params.dart';
import '../../../domain/usecases/set_scholarship_step/result_typedef.dart';

abstract class Datasource {
  Result call(Params params);
  const Datasource();
}
