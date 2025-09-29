import '../../../domain/usecases/send_proof_document_with_pendences/entity.dart';
import '../../../domain/usecases/send_proof_document_with_pendences/params.dart';

abstract class Datasource {
  Future<Entity> call(Params params);

  const Datasource();
}
