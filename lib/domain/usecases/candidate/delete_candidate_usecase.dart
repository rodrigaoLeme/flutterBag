class DeleteCandidateParams {
  final String scholarshipId;
  final String studentId;

  const DeleteCandidateParams({
    required this.scholarshipId,
    required this.studentId,
  });
}

abstract class DeleteCandidateUsecase {
  Future<void> delete(DeleteCandidateParams params);
}

class DeleteCandidateException implements Exception {
  final String message;
  const DeleteCandidateException(this.message);
}
