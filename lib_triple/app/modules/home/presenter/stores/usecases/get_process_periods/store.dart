import 'package:flutter_triple/flutter_triple.dart';

import '../../../../domain/usecases/get_process_periods/entity.dart';
import '../../../../domain/usecases/get_process_periods/exceptions.dart';
import '../../../../domain/usecases/get_process_periods/params.dart';
import '../../../../domain/usecases/get_process_periods/usecase.dart';
export '../../../../domain/usecases/get_process_periods/params.dart';

class Store extends StreamStore<UsecaseException, Entity> {
  final Usecase _usecase;

  Store(this._usecase) : super(Entity.empty());

  Future<void> call(Params params) async {
    setLoading(true);
    final result = await _usecase(params);
    result.fold(
      (exception) {
        setError(exception);
      },
      (entity) {
        update(entity);
      },
    );
    setLoading(false);
  }
}
