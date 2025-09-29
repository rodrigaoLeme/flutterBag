import 'package:localization/localization.dart';

import '../../../domain/usecases/get_processes_years/entity.dart';
import '../../../domain/usecases/get_processes_years/exceptions.dart';

class Mapper {
  Entity fromListToEntity(dynamic result) {
    isResultDataAList(result, 'processes_years');
    final newList = <int>[];
    for (final element in result) {
      if (element == null) continue;
      newList.add(element);
    }
    return Entity(newList);
  }

  const Mapper();
}

void isResultDataAList(dynamic result, String usecase) {
  if (result == null || result is! List) {
    throw MapperException(
        message: "global_mapper_unexpected_result_data_format".i18n([
      "${usecase}_unexpected_result_data_format".i18n()
    ]));
  }
}
