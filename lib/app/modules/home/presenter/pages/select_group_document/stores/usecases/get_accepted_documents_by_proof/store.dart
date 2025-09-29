import 'package:flutter_triple/flutter_triple.dart';

import '../../../../../../domain/usecases/get_accepted_documents_by_proof/entity.dart';
import '../../../../../../domain/usecases/get_accepted_documents_by_proof/exceptions.dart';
import '../../../../../../domain/usecases/get_accepted_documents_by_proof/params.dart';
import '../../../../../../domain/usecases/get_accepted_documents_by_proof/usecase.dart';
export '../../../../../../domain/usecases/get_accepted_documents_by_proof/params.dart';
export '../../../../../../domain/usecases/get_accepted_documents_by_proof/exceptions.dart';
export '../../../../../../domain/usecases/get_accepted_documents_by_proof/entity.dart';

class Store extends StreamStore<UsecaseException, Entity> {
  final Usecase _usecase;

  Store(this._usecase) : super(Entity.empty());

  Future<void> call(Params params) async {
    setLoading(true);
    final result = await _usecase(params);
    result.fold(
      (exception) {
        setError(exception, force: true);
      },
      (entity) {
        update(entity, force: true);
      },
    );
    setLoading(false);
  }
}
