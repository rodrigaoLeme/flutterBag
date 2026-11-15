import '../../entities/proof_attachment_entity.dart';

class UploadProofDocumentParams {
  final String scholarshipId;
  final String proofDocumentId;
  final String documentId;
  final bool acceptTerm;
  final ProofAttachments attachments;
  final String? reviewId;
  final String? senderObservation;

  const UploadProofDocumentParams({
    required this.scholarshipId,
    required this.proofDocumentId,
    required this.documentId,
    required this.acceptTerm,
    required this.attachments,
    this.reviewId,
    this.senderObservation,
  });
}

class UploadProofDocumentResult {
  final bool archived;
  const UploadProofDocumentResult({this.archived = false});
}

enum UploadProofFailure { passwordRequired, invalidPassword, other }

abstract class UploadProofDocumentUsecase {
  Future<UploadProofDocumentResult> upload(
    UploadProofDocumentParams params, {
    void Function(int sent, int total)? onProgress,
  });
}

class UploadProofDocumentException implements Exception {
  final String message;
  final UploadProofFailure failure;

  const UploadProofDocumentException(
    this.message, {
    this.failure = UploadProofFailure.other,
  });
}
