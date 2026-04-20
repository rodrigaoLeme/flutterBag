import 'params.dart';
import 'result_typedef.dart';

abstract class Usecase {
  Result call(Params params);
}
