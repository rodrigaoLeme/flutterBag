import 'package:flutter_triple/flutter_triple.dart';

import '../../../../../../domain/usecases/forgot_password/exceptions.dart';
import '../../../../../../domain/usecases/forgot_password/params.dart';
import '../../../../../../domain/usecases/forgot_password/usecase.dart';
import '../../../../../../domain/usecases/forgot_password/entity.dart';
export '../../../../../../domain/usecases/forgot_password/params.dart';
export '../../../../../../domain/usecases/forgot_password/entity.dart';
export '../../../../../../domain/usecases/forgot_password/exceptions.dart';

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

  void reset() {
    update(Entity.empty());
  }
}
