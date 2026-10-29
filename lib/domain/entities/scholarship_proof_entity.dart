import 'enrollment_enums.dart';
import 'proof_document_entity.dart';

class ScholarshipProofEntity {
  final String id;
  final String? proofName;
  final String? categoryName;
  final String? contextLabel;
  final String? referenceDescription;
  final int? reviewStatus;
  final List<ProofDocumentEntity> scholarshipProofDocuments;
  final String? familyMemberId;
  final String? familyMemberName;
  final String? studentId;
  final ScholarshipProofReference? proofReference;

  const ScholarshipProofEntity({
    required this.id,
    this.proofName,
    this.categoryName,
    this.contextLabel,
    this.referenceDescription,
    this.familyMemberId,
    this.familyMemberName,
    this.studentId,
    this.proofReference,
    this.reviewStatus,
    this.scholarshipProofDocuments = const [],
  });

  bool get isFamilyGroup =>
      proofReference == ScholarshipProofReference.familyGroup;

  int get totalSlots => scholarshipProofDocuments.length;

  int get uploadedSlots =>
      scholarshipProofDocuments.where((d) => d.hasFile).length;

  bool get isComplete =>
      scholarshipProofDocuments.isNotEmpty &&
      scholarshipProofDocuments.every((d) => d.hasFile);

  factory ScholarshipProofEntity.fromJson(Map<String, dynamic> json) =>
      ScholarshipProofEntity(
        id: json['id'] as String,
        proofName: json['proofName'] as String?,
        categoryName: json['categoryName'] as String?,
        contextLabel: json['contextLabel'] as String?,
        referenceDescription: json['referenceDescription'] as String?,
        familyMemberId: json['familyMemberId'] as String?,
        familyMemberName: json['familyMemberName'] as String?,
        studentId: json['studentId'] as String?,
        proofReference: ScholarshipProofReference.fromValue(
          json['scholarshipProofReference'] as int?,
        ),
        reviewStatus: json['reviewStatus'] as int?,
        scholarshipProofDocuments: (json['scholarshipProofDocuments'] as List?)
                ?.map((e) => ProofDocumentEntity.fromJson(
                    Map<String, dynamic>.from(e as Map)))
                .toList() ??
            [],
      );
}
