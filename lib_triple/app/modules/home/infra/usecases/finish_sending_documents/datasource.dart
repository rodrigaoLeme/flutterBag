import '../../../domain/usecases/finish_sending_documents/params.dart';
import '../../../domain/usecases/finish_sending_documents/result_typedef.dart';

abstract class Datasource {
  Result call(Params params);

  const Datasource();
}
