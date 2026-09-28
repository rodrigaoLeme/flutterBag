class SetScholarshipStepParams {
  final String scholarshipId;
  final int step;

  const SetScholarshipStepParams({
    required this.scholarshipId,
    required this.step,
  });
}

abstract class SetScholarshipStepUsecase {
  Future<void> set(SetScholarshipStepParams params);
}

class SetScholarshipStepException implements Exception {
  final String message;
  const SetScholarshipStepException(this.message);
}
