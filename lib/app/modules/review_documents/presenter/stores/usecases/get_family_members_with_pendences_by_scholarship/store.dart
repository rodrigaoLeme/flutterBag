import 'package:flutter_triple/flutter_triple.dart';

import '../../../../domain/usecases/get_family_members_with_pendences_by_scholarship/entity.dart';
import '../../../../domain/usecases/get_family_members_with_pendences_by_scholarship/params.dart';
import '../../../../domain/usecases/get_family_members_with_pendences_by_scholarship/usecase.dart';
export '../../../../domain/usecases/get_family_members_with_pendences_by_scholarship/entity.dart';
export '../../../../domain/usecases/get_family_members_with_pendences_by_scholarship/params.dart';
export '../../../../domain/usecases/get_family_members_with_pendences_by_scholarship/exceptions.dart';

class Store extends StreamStore<String, Entity> {
  final Usecase _usecase;

  Store(this._usecase) : super(Entity.empty());

  Future<void> call(Params params) async {
    setLoading(true);
    final result = await _usecase(params);
    result.fold(
      (exception) {
        setError('Não foi possível recuperar os familiares com pendências');
      },
      (entity) {
        update(entity);
      },
    );
    setLoading(false);
  }
}
