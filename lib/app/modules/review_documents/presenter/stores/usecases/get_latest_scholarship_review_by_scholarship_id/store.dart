import 'package:flutter_triple/flutter_triple.dart';

import '../../../../domain/usecases/get_latest_scholarship_review_by_scholarship_id/entity.dart';
import '../../../../domain/usecases/get_latest_scholarship_review_by_scholarship_id/params.dart';
import '../../../../domain/usecases/get_latest_scholarship_review_by_scholarship_id/usecase.dart';
export '../../../../domain/usecases/get_latest_scholarship_review_by_scholarship_id/params.dart';
export '../../../../domain/usecases/get_latest_scholarship_review_by_scholarship_id/entity.dart';

class Store extends StreamStore<String, Entity> {
  final Usecase _usecase;

  Store(this._usecase) : super(Entity.empty());

  Future<void> call(Params params) async {
    setLoading(true, force: true);
    final result = await _usecase(params);
    result.fold(
      (exception) {
        setError('Não foi possível recuperar o id da última revisão', force: true);
      },
      (entity) {
        update(entity, force: true);
      },
    );
    setLoading(false, force: true);
  }
}
