import '../../../domain/usecases/finish_sending_documents_with_pendences/params.dart';
import '../../../domain/usecases/finish_sending_documents_with_pendences/result_typedef.dart';

abstract class Datasource {
  Result call(Params params);

  const Datasource();
}
