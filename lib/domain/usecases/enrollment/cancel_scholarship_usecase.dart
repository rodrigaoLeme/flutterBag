class CancelScholarshipParams {
  final String scholarshipId;
  final String? cancelObservation;

  const CancelScholarshipParams({
    required this.scholarshipId,
    this.cancelObservation,
  });
}

abstract class CancelScholarshipUsecase {
  Future<void> cancel(CancelScholarshipParams params);
}

class CancelScholarshipException implements Exception {
  final String message;
  const CancelScholarshipException(this.message);
}
