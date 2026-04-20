import '../../../domain/usecases/get_proofs_with_pendences_by_family_params/entity.dart';
import '../../../domain/usecases/get_proofs_with_pendences_by_family_params/params.dart';

abstract class Datasource {
  Future<Entity> call(Params params);

  const Datasource();
}
