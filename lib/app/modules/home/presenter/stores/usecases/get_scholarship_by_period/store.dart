import 'package:flutter_triple/flutter_triple.dart';

import '../../../../../../core/constants/process_type.dart';
import '../../../../domain/usecases/get_scholarship_by_period/entity.dart';
import '../../../../domain/usecases/get_scholarship_by_period/params.dart';
import '../../../../domain/usecases/get_scholarship_by_period/usecase.dart';
export '../../../../domain/usecases/get_scholarship_by_period/exceptions.dart';
export '../../../../domain/usecases/get_scholarship_by_period/entity.dart';
export '../../../../domain/usecases/get_scholarship_by_period/params.dart';
part 'states.dart';

class Store extends StreamStore<String, StoreState> {
  final Usecase _usecase;

  Store(this._usecase) : super(Initial());

  Future<void> call(Params params, ProcessType processType) async {
    setLoading(true);
    final result = await _usecase(params);
    result.fold(
      (exception) {
        setError('Não foi possível buscar um processo');
      },
      (entity) {
        switch (processType) {
          case ProcessType.fresh:
            update(Set(processNew: entity, processRenewal: state.processRenewal));
            break;
          case ProcessType.renewal:
            update(Set(processNew: state.processNew, processRenewal: entity));
            break;
        }
      },
    );
    setLoading(false);
  }
}
