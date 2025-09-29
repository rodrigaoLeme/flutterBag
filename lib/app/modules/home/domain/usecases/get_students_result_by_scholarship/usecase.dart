import 'params.dart';
import 'result_typedef.dart';

/// Interface que define o contrato do caso de uso
abstract class Usecase {
  Result call(Params params);
}
