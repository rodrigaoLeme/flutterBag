import '../../../domain/usecases/get_family_members_by_scholarship/params.dart';
import '../group_params.dart';
import '../scholarship_params.dart';
import '../select_group_document/stores/usecases/get_proofs_by_family_params/store.dart'
    as get_proofs_by_family_member;
import 'stores/usecases/finish_sending_documents/store.dart'
    as finish_sending_documents;
import 'stores/usecases/get_family_members_by_scholarship/store.dart'
    as get_family_members_by_scholarship;

class SelectGroupController {
  final get_family_members_by_scholarship.Store getFamilyMembers;
  final finish_sending_documents.Store finishSendingDocumentsStore;
  final get_proofs_by_family_member.Store getProofs;
  final ScholarshipParams scholarshipParams;
  final GroupParams params;
  String _scholarshipId = '';

  SelectGroupController(this.params, this.getFamilyMembers,
      this.scholarshipParams, this.getProofs, this.finishSendingDocumentsStore);

  void selectGroup(GroupParams params) {
    this.params.proofParams = params.proofParams;
    this.params.icon = params.icon;
    this.params.groupName = params.groupName;
  }

  Future<void> getFamilyMembersByScholarship() async {
    if (scholarshipParams.id != _scholarshipId) {
      _scholarshipId = scholarshipParams.id;
      await getFamilyMembers(Params(scholarshipId: _scholarshipId));
    }
  }

  Future<bool>? showFinishButtonResult;

  Future<bool> showFinishButton() async {
    final familyMembers = getFamilyMembers.state.familyMembers;
    for (int i = 0; i < familyMembers.length + 1; i++) {
      if (i == 0) {
        await getProofs(get_proofs_by_family_member.FamilyGroupParams(
            scholarshipId: scholarshipParams.id));
      } else {
        await getProofs(get_proofs_by_family_member.FamilyMemberParams(
            familyMemberId: familyMembers[i - 1].id,
            scholarshipId: scholarshipParams.id));
      }
      if (getProofs.error != null) {
        return false;
      }
      if (getProofs.state.proofs.any((element) => element
          .scholarshipProofDocuments
          .any((element) => element.fileId == null))) {
        return false;
      }
    }
    return true;
  }

  void finishSendingDocuments() {
    if (_scholarshipId.isEmpty) return;
    finishSendingDocumentsStore(
        finish_sending_documents.Params(scholarshipId: _scholarshipId));
  }
}
