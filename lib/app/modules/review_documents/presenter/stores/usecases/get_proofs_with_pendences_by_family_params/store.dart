import 'package:flutter_triple/flutter_triple.dart';

import '../../../../domain/usecases/get_proofs_with_pendences_by_family_params/entity.dart';
import '../../../../domain/usecases/get_proofs_with_pendences_by_family_params/params.dart';
import '../../../../domain/usecases/get_proofs_with_pendences_by_family_params/usecase.dart';
export '../../../../domain/usecases/get_proofs_with_pendences_by_family_params/params.dart';
export '../../../../domain/usecases/get_proofs_with_pendences_by_family_params/entity.dart';

class Store extends StreamStore<String, Entity> {
  final Usecase _usecase;

  Store(this._usecase) : super(Entity.empty());

  Future<void> call(Params params) async {
    setLoading(true, force: true);
    final result = await _usecase(params);
    result.fold(
      (exception) {
        setError('Não foi possível recuperar os comprovantes com pendências', force: true);
      },
      (entity) {
        update(entity, force: true);
      },
    );
    setLoading(false, force: true);
  }
}
