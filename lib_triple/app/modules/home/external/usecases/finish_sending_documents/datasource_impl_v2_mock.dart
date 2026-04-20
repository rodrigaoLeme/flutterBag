import 'package:either_dart/either.dart';

import '../../../domain/usecases/finish_sending_documents/entity.dart';
//import '../../../domain/usecases/finish_sending_documents/exceptions.dart';
import '../../../domain/usecases/finish_sending_documents/params.dart';
import '../../../domain/usecases/finish_sending_documents/result_typedef.dart';
import '../../../infra/usecases/finish_sending_documents/datasource.dart';

class DatasourceImplV2Mock implements Datasource {
  const DatasourceImplV2Mock();

  @override
  Result call(Params params) async {
    await Future.delayed(const Duration(seconds: 3));
    return const Right(Entity(response: true));
    //return const Left(ServerException());
  }
}
