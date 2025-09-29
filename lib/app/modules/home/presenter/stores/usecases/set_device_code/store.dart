import 'package:flutter_triple/flutter_triple.dart';

import '../../../../domain/usecases/set_device_code/entity.dart';
import '../../../../domain/usecases/set_device_code/exceptions.dart';
import '../../../../domain/usecases/set_device_code/params.dart';
import '../../../../domain/usecases/set_device_code/usecase.dart';

export '../../../../domain/usecases/set_device_code/params.dart';

class Store extends StreamStore<UsecaseException, Entity> {
  final Usecase _usecase;

  Store(this._usecase) : super(Entity.empty());

  Future<void> call(Params params) async {
    if (!_canStart(params) && !_canFinish(params)) {
      return;
    }
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

  bool _canStart(Params params) {
    return params.operation == SetDeviceCodeOperation.start && state.response == false;
  }

  bool _canFinish(Params params) {
    return params.operation == SetDeviceCodeOperation.finish && state.response == true;
  }
}
