// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import '../../../../home/domain/usecases/get_accepted_documents_by_proof/entity.dart';
import '../../../domain/usecases/get_proofs_with_pendences_by_family_params/entity.dart';
import '../../../domain/usecases/get_proofs_with_pendences_by_family_params/params.dart';

class RequiredDocumentsWithPendencesDto {
  final IconData icon;
  final String groupName;
  final String groupDocumentName;
  final List<ScholarshipProofDocumentWithPendences> scholarshipProofDocuments;
  final List<AcceptedDocument> acceptedDocuments;
  final bool isEdit;
  final String proofId;
  final Params getProofsWithPendencesParams;
  final String scholarshipReviewId;
  final ProofWithPendences proofs;

  RequiredDocumentsWithPendencesDto({
    required this.icon,
    required this.groupName,
    required this.groupDocumentName,
    required this.scholarshipProofDocuments,
    required this.acceptedDocuments,
    required this.isEdit,
    required this.proofId,
    required this.getProofsWithPendencesParams,
    required this.scholarshipReviewId,
    required this.proofs,
  });
}
