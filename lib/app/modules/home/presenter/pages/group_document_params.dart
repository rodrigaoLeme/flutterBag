import 'package:flutter/material.dart';

import '../../domain/usecases/get_accepted_documents_by_proof/entity.dart';
import '../../domain/usecases/get_proofs_by_family_params/entity.dart';

class GroupDocumentParams {
  IconData? icon;
  String? groupName;
  String? groupDocumentName;
  List<ScholarshipProofDocument>? scholarshipProofDocuments;
  List<AcceptedDocument>? acceptedDocuments;
  bool isEdit;
  String? proofId;
  Proof? proof;

  GroupDocumentParams({
    required this.icon,
    required this.groupName,
    required this.groupDocumentName,
    required this.scholarshipProofDocuments,
    required this.acceptedDocuments,
    this.isEdit = false,
    required this.proofId,
    required this.proof,
  });
  factory GroupDocumentParams.empty() => GroupDocumentParams(
        icon: null,
        groupName: '',
        groupDocumentName: '',
        scholarshipProofDocuments: [],
        acceptedDocuments: [],
        proofId: '',
        proof: null,
      );
}
