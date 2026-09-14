class DeleteFamilyMemberParams {
  final String scholarshipId;
  final String memberId;

  const DeleteFamilyMemberParams({
    required this.scholarshipId,
    required this.memberId,
  });
}

abstract class DeleteFamilyMemberUsecase {
  Future<void> delete(DeleteFamilyMemberParams params);
}

class DeleteFamilyMemberException implements Exception {
  final String message;
  const DeleteFamilyMemberException(this.message);
}
