import 'package:flutter_triple/flutter_triple.dart';

import '../../../../domain/usecases/send_proof_document_with_pendences/entity.dart';
import '../../../../domain/usecases/send_proof_document_with_pendences/params.dart';
import '../../../../domain/usecases/send_proof_document_with_pendences/usecase.dart';

export '../../../../domain/usecases/send_proof_document_with_pendences/entity.dart';
export '../../../../domain/usecases/send_proof_document_with_pendences/exceptions.dart';
export '../../../../domain/usecases/send_proof_document_with_pendences/params.dart';

class Store extends StreamStore<String, Entity> {
  final Usecase _usecase;

  Store(this._usecase) : super(const Entity());

  Future<void> call(Params params) async {
    setLoading(true, force: true);
    final result = await _usecase(params);
    result.fold(
      (exception) => setError(exception.message!, force: true),
      (entity) => update(entity, force: true),
    );
    setLoading(false, force: true);
  }
}
