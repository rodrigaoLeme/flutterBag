import 'package:flutter_triple/flutter_triple.dart';

import '../../../../../domain/usecases/get_document_by_file_id/entity.dart';
import '../../../../../domain/usecases/get_document_by_file_id/exceptions.dart';
import '../../../../../domain/usecases/get_document_by_file_id/params.dart';
import '../../../../../domain/usecases/get_document_by_file_id/usecase.dart';
export '../../../../../domain/usecases/get_document_by_file_id/params.dart';

class Store extends StreamStore<UsecaseException, Entity> {
  final Usecase _usecase;

  Store(this._usecase) : super(Entity.empty());

  Future<void> call(Params params) async {
    setLoading(true, force: true);
    final result = await _usecase(params);
    result.fold(
      (exception) {
        setError(exception);
      },
      (entity) {
        update(entity, force: true);
      },
    );
    setLoading(false, force: true);
  }
}
