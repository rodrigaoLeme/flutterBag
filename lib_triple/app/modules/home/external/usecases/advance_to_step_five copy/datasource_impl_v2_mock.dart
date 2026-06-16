import 'package:either_dart/either.dart';

import '../../../domain/usecases/set_scholarship_step/entity.dart';
import '../../../domain/usecases/set_scholarship_step/params.dart';
import '../../../domain/usecases/set_scholarship_step/result_typedef.dart';
import '../../../infra/usecases/set_scholarship_step/datasource.dart';

class DatasourceImplV2Mock implements Datasource {
  const DatasourceImplV2Mock();

  @override
  Result call(Params params) async {
    await Future.delayed(const Duration(seconds: 1));
    return const Right(Entity(response: true));
  }
}
