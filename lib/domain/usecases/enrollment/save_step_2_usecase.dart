import '../../entities/group_income_entity.dart';

class SaveStep2Params {
  final String scholarshipId;
  final GroupIncomeEntity groupIncome;

  const SaveStep2Params({
    required this.scholarshipId,
    required this.groupIncome,
  });
}

abstract class SaveStep2Usecase {
  Future<void> save(SaveStep2Params param);
}
