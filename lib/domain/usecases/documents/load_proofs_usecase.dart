import '../../entities/scholarship_proof_entity.dart';

abstract class LoadProofsUsecase {
  Future<List<ScholarshipProofEntity>> load(String scholarshipId);
}

class LoadProofsException implements Exception {
  final String message;
  const LoadProofsException(this.message);
}
