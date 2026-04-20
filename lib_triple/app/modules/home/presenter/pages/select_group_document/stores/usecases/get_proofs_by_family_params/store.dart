import 'package:flutter_triple/flutter_triple.dart';

import '../../../../../../domain/usecases/get_proofs_by_family_params/entity.dart';
import '../../../../../../domain/usecases/get_proofs_by_family_params/exceptions.dart';
import '../../../../../../domain/usecases/get_proofs_by_family_params/params.dart';
import '../../../../../../domain/usecases/get_proofs_by_family_params/usecase.dart';

export '../../../../../../domain/usecases/get_proofs_by_family_params/params.dart';

class Store extends StreamStore<UsecaseException, Entity> {
  final Usecase _usecase;

  Store(this._usecase) : super(Entity.empty());

  Future<void> call(Params params) async {
    setLoading(true, force: true);
    final result = await _usecase(params);
    result.fold(
      (exception) {
        setError(exception, force: true);
      },
      (entity) {
        update(entity, force: true);
      },
    );
    setLoading(false, force: true);
  }
}
