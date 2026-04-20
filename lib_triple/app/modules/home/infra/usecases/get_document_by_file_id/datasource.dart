import '../../../domain/usecases/get_document_by_file_id/entity.dart';
import '../../../domain/usecases/get_document_by_file_id/params.dart';

abstract class Datasource {
  Future<Entity> call(Params params);

  const Datasource();
}
