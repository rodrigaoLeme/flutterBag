import '../../entities/expenses_entity.dart';

class SaveStep3Params {
  final String scholarshipId;
  final ExpensesEntity expenses;

  const SaveStep3Params({
    required this.scholarshipId,
    required this.expenses,
  });
}

abstract class SaveStep3Usecase {
  Future<void> save(SaveStep3Params params);
}
