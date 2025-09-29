import 'package:either_dart/either.dart';

import '../../../domain/usecases/finish_sending_documents_with_pendences/entity.dart';
//import '../../../domain/usecases/finish_sending_documents_with_pendences/exceptions.dart';
import '../../../domain/usecases/finish_sending_documents_with_pendences/params.dart';
import '../../../domain/usecases/finish_sending_documents_with_pendences/result_typedef.dart';
import '../../../infra/usecases/finish_sending_documents_with_pendences/datasource.dart';

class DatasourceImplV2Mock implements Datasource {
  const DatasourceImplV2Mock();

  @override
  Result call(Params params) async {
    await Future.delayed(const Duration(seconds: 3));
    return const Right(Entity(response: true));
    //return const Left(ServerException());
  }
}
