import 'package:flutter_triple/flutter_triple.dart';

import '../../../../../domain/usecases/send_proof_document/exceptions.dart';
import '../../../../../domain/usecases/send_proof_document/params.dart';
import '../../../../../domain/usecases/send_proof_document/usecase.dart';
import '../../../../../domain/usecases/send_proof_document/entity.dart';
export '../../../../../domain/usecases/send_proof_document/params.dart';
export '../../../../../domain/usecases/send_proof_document/exceptions.dart';

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
