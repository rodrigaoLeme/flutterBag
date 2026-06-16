import 'package:either_dart/either.dart';

import '../../../domain/usecases/advance_to_step_five/entity.dart';
import '../../../domain/usecases/advance_to_step_five/params.dart';
import '../../../domain/usecases/advance_to_step_five/result_typedef.dart';
import '../../../infra/usecases/advance_to_step_five/datasource.dart';

class DatasourceImplV2Mock implements Datasource {
  const DatasourceImplV2Mock();

  @override
  Result call(Params params) async {
    await Future.delayed(const Duration(seconds: 1));
    return const Right(Entity(response: true));
  }
}
