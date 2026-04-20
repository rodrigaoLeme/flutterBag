import '../../../domain/usecases/send_proof_document/entity.dart';
import '../../../domain/usecases/send_proof_document/params.dart';

abstract class Datasource {
  Future<Entity> call(Params params);

  const Datasource();
}
