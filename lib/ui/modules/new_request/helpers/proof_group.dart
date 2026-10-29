import '../../../../domain/entities/scholarship_proof_entity.dart';
import '../steps/documents/document_group_item.dart';

class ProofGroup {
  final String id;
  final String title;
  final DocumentGroupType type;
  final List<ScholarshipProofEntity> proofs = [];

  ProofGroup({
    required this.id,
    required this.title,
    required this.type,
  });

  void addProof(ScholarshipProofEntity proof) => proofs.add(proof);

  // Conta cada ProofDocument individualmente (não cada Proof)
  int get totalSlots =>
      proofs.fold(0, (sum, p) => sum + p.scholarshipProofDocuments.length);

  int get uploadedSlots => proofs.fold(
      0,
      (sum, p) =>
          sum + p.scholarshipProofDocuments.where((d) => d.hasFile).length);
}
