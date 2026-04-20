import '../../../domain/usecases/get_accepted_documents_by_proof/entity.dart';
import '../../../domain/usecases/get_accepted_documents_by_proof/params.dart';

abstract class Datasource {
  Future<Entity> call(Params params);

  const Datasource();
}
