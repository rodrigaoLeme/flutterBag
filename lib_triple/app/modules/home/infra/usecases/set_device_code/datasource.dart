import '../../../domain/usecases/set_device_code/params.dart';
import '../../../domain/usecases/set_device_code/result_typedef.dart';

abstract class Datasource {
  Result call(Params params);

  const Datasource();
}
