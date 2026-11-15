import 'proof_attachment_entity.dart';

class ProofSlotSubmission {
  final String documentId;
  final bool acceptTerm;
  final ProofAttachments attachments;

  const ProofSlotSubmission({
    required this.documentId,
    required this.acceptTerm,
    required this.attachments,
  });
}
