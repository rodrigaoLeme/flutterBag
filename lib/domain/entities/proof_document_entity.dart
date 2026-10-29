import 'proof_document_option_entity.dart';

class ProofDocumentEntity {
  final String id;
  final String? proofItemConfigId;
  final String? documentId;
  final String? documentName;
  final String? filename;
  final bool hasFile;
  final bool? isValid;
  final bool acceptedTerm;
  final bool lastReviewInvalid;
  final bool isComplementary;
  final List<ProofDocumentOptionEntity> options;

  const ProofDocumentEntity({
    required this.id,
    this.proofItemConfigId,
    this.documentId,
    this.documentName,
    this.filename,
    required this.hasFile,
    this.isValid,
    required this.acceptedTerm,
    required this.lastReviewInvalid,
    required this.isComplementary,
    this.options = const [],
  });

  bool get isComplete => hasFile;

  bool get needsReview => lastReviewInvalid;

  ProofDocumentOptionEntity? get autoSelectedOption =>
      options.length == 1 ? options.first : null;

  factory ProofDocumentEntity.fromJson(Map<String, dynamic> json) =>
      ProofDocumentEntity(
        id: json['id'] as String,
        proofItemConfigId: json['proofItemConfigId'] as String?,
        documentId: json['documentId'] as String?,
        documentName: json['documentName'] as String?,
        filename: json['filename'] as String?,
        hasFile: json['hasFile'] as bool? ?? false,
        isValid: json['isValid'] as bool?,
        acceptedTerm: json['acceptedTerm'] as bool? ?? false,
        lastReviewInvalid: json['lastReviewInvalid'] as bool? ?? false,
        isComplementary: json['isComplementary'] as bool? ?? false,
        options: (json['options'] as List?)
                ?.map((e) => ProofDocumentOptionEntity.fromJson(
                    Map<String, dynamic>.from(e as Map)))
                .toList() ??
            [],
      );
}
