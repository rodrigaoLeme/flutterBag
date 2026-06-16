import 'package:flutter_triple/flutter_triple.dart';

import '../../../../../../domain/usecases/advance_to_step_five/entity.dart';
import '../../../../../../domain/usecases/advance_to_step_five/exceptions.dart';
import '../../../../../../domain/usecases/advance_to_step_five/params.dart';
import '../../../../../../domain/usecases/advance_to_step_five/usecase.dart';

export '../../../../../../domain/usecases/advance_to_step_five/entity.dart';
export '../../../../../../domain/usecases/advance_to_step_five/exceptions.dart';
export '../../../../../../domain/usecases/advance_to_step_five/params.dart';

class Store extends StreamStore<UsecaseException, Entity> {
  final Usecase _usecase;

  Store(this._usecase) : super(Entity.empty());

  Future<void> call(Params params) async {
    setLoading(true, force: true);
    final result = await _usecase(params);
    result.fold(
      (exception) {
        setError(exception, force: true);
        update(state, force: true);
      },
      (entity) {
        update(entity, force: true);
      },
    );
    setLoading(false, force: true);
  }
}
