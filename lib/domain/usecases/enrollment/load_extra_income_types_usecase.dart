import '../../entities/extra_income_type_entity.dart';

abstract class LoadExtraIncomeTypesUsecase {
  Future<List<ExtraIncomeTypeEntity>> load();
}

class LoadExtraIncomeTypesException implements Exception {
  final String message;
  const LoadExtraIncomeTypesException(this.message);
}
