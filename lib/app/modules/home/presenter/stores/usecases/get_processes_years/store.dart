import 'package:flutter_triple/flutter_triple.dart';

import '../../../../domain/usecases/get_processes_years/entity.dart';
import '../../../../domain/usecases/get_processes_years/exceptions.dart';
import '../../../../domain/usecases/get_processes_years/params.dart';
import '../../../../domain/usecases/get_processes_years/usecase.dart';
export '../../../../domain/usecases/get_processes_years/params.dart';
export '../../../../domain/usecases/get_processes_years/exceptions.dart';
export '../../../../domain/usecases/get_processes_years/entity.dart';

class Store extends StreamStore<UsecaseException, Entity> {
  final Usecase _usecase;

  Store(this._usecase) : super(Entity.empty());

  Future<void> call() async {
    setLoading(true);
    final result = await _usecase(const Params());
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
