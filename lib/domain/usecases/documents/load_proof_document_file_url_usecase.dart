import '../../entities/proof_document_file_url_entity.dart';

abstract class LoadProofDocumentFileUrlUsecase {
  Future<ProofDocumentFileUrlEntity> load({
    required String scholarshipId,
    required String proofDocumentId,
  });
}

class LoadProofDocumentFileUrlException implements Exception {
  final String message;
  const LoadProofDocumentFileUrlException(this.message);
}
