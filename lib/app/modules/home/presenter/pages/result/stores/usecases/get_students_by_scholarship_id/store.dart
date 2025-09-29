import 'package:flutter_triple/flutter_triple.dart';

import '../../../../../../domain/usecases/get_students_by_scholarship_id/entity.dart';
import '../../../../../../domain/usecases/get_students_by_scholarship_id/params.dart';
import '../../../../../../domain/usecases/get_students_by_scholarship_id/usecase.dart';
import 'store_exception.dart';
export '../../../../../../domain/usecases/get_students_by_scholarship_id/entity.dart';
export '../../../../../../domain/usecases/get_students_by_scholarship_id/exceptions.dart';

class Store extends StreamStore<StoreException, Entity> {
  final Usecase _usecase;

  Store(this._usecase) : super(Entity.empty());

  Future<void> call(Params params) async {
    setLoading(true);
    final result = await _usecase(params);
    result.fold(
      (exception) {
        setError(StoreException('Não foi possível receber o resultado do processo'));
      },
      (entity) {
        update(entity);
      },
    );
    setLoading(false);
  }
}
