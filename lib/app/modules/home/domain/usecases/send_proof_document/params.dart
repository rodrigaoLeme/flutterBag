import 'dart:io';

class Params {
  final File file;
  final String scholarshipProofDocumentId;
  final String documentId;
  final bool acceptTerm;
  final String origin;

  const Params({
    required this.file,
    required this.scholarshipProofDocumentId,
    required this.documentId,
    required this.acceptTerm,
    required this.origin,
  });
}
