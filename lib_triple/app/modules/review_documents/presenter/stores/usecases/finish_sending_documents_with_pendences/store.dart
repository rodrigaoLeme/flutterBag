import 'package:flutter_triple/flutter_triple.dart';

import '../../../../domain/usecases/finish_sending_documents_with_pendences/entity.dart';
import '../../../../domain/usecases/finish_sending_documents_with_pendences/params.dart';
import '../../../../domain/usecases/finish_sending_documents_with_pendences/usecase.dart';
import 'store_exception.dart';

export '../../../../domain/usecases/finish_sending_documents_with_pendences/entity.dart';
export '../../../../domain/usecases/finish_sending_documents_with_pendences/params.dart';
export 'store_exception.dart';

class Store extends StreamStore<StoreException, Entity> {
  final Usecase _usecase;

  Store(this._usecase) : super(Entity.empty());

  Future<void> call(Params params) async {
    setLoading(true);
    final result = await _usecase(params);
    result.fold(
      (exception) {
        setError(
            StoreException(exception.message ??
                'Não foi possível finalizar o envio de documentos com pendências'),
            force: true);
        setLoading(false);
      },
      (entity) {
        update(entity);
      },
    );
  }
}
