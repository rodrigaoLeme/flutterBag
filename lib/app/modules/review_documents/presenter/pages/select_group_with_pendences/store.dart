import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart' as triple;

import '../../../../../core/icons/ebolsas_icons_icons.dart';
import '../../../domain/usecases/get_proofs_with_pendences_by_family_params/params.dart';
import '../../stores/usecases/finish_sending_documents_with_pendences/store.dart'
    as finish_sending_documents_with_pendences;
import '../../stores/usecases/get_family_members_with_pendences_by_scholarship/store.dart'
    as get_family_members_with_pendences_by_scholarship;
import '../../stores/usecases/get_latest_scholarship_review_by_scholarship_id/store.dart'
    as get_latest_scholarship_review_by_scholarship_id;
import '../../stores/usecases/get_proofs_with_pendences_by_family_params/store.dart'
    as get_proofs_with_pendences_by_family_member;
import '../select_group_document_with_pendences/group_with_pendences_dto.dart';
import '../select_group_document_with_pendences/imports.dart'
    as select_group_document;
import 'scholarship_with_pendences_dto.dart';

part 'store_states.dart';

class Store extends triple.StreamStore<String, StoreState> {
  final get_family_members_with_pendences_by_scholarship.Store
      getFamilyMembersWithPendencesStore;
  final get_latest_scholarship_review_by_scholarship_id.Store
      getLatestScholarshipReviewStore;
  final finish_sending_documents_with_pendences.Store
      finishSendingDocumentsStore;
  final get_proofs_with_pendences_by_family_member.Store
      getProofsWithPendencesStore;

  Store(
      this.getFamilyMembersWithPendencesStore,
      this.getLatestScholarshipReviewStore,
      this.finishSendingDocumentsStore,
      this.getProofsWithPendencesStore)
      : super(const Set());

  bool get hasFamilyGroupPendences =>
      getLatestScholarshipReviewStore.state.hasFamilyGroupPendences;

  void init({required String scholarshipId}) {
    if (scholarshipId == state.scholarshipWithPendencesDto.id) return;
    update(state.copyWith(
        scholarshipWithPendencesDto:
            ScholarshipWithPendencesDto(id: scholarshipId)));
    setLoading(true);
    getFamilyMembersByScholarship().then((value) {
      return getLatestScholarshipReviewId().then((value) {
        return checkFinishButton();
      });
    }).whenComplete(() => setLoading(false));
  }

  Future<void> getFamilyMembersByScholarship() async {
    await getFamilyMembersWithPendencesStore(
        get_family_members_with_pendences_by_scholarship.Params(
            scholarshipId: state.scholarshipWithPendencesDto.id));
  }

  Future<void> getLatestScholarshipReviewId() async {
    await getLatestScholarshipReviewStore(
      get_latest_scholarship_review_by_scholarship_id.Params(
          scholarshipId: state.scholarshipWithPendencesDto.id),
    );
    if (getLatestScholarshipReviewStore.error == null) {
      update(state.copyWith(
          scholarshipReviewId: getLatestScholarshipReviewStore.state.id));
    }
  }

  void selectFamilyGroup() {
    update(
      state.copyWith(
        groupWithPendencesDto: GroupWithPendencesDto(
          getProofsWithPendencesParams: FamilyGroupParams(
            scholarshipReviewId: state.scholarshipReviewId,
          ),
          groupName: 'Grupo Familiar',
          groupIcon: EbolsasIcons.icon_metro_home,
          scholarshipReviewId: state.scholarshipReviewId,
        ),
      ),
    );
  }

  void selectFamilyMemberGroup(
      {required String familyMemberId, required String familyMemberName}) {
    update(
      state.copyWith(
        groupWithPendencesDto: GroupWithPendencesDto(
          getProofsWithPendencesParams: FamilyMemberParams(
            scholarshipReviewId: state.scholarshipReviewId,
            familyMemberId: familyMemberId,
          ),
          groupName: familyMemberName,
          groupIcon: Icons.person_rounded,
          scholarshipReviewId: state.scholarshipReviewId,
        ),
      ),
    );
  }

  Future<void> goToSelectGroupDocumentPage() => Modular.to.pushNamed(
        select_group_document.route,
        arguments: state.groupWithPendencesDto,
      );

  Future<void> checkFinishButton() async {
    if (!isLoading) setLoading(true);
    final check = await _showFinishButton();
    update(state.copyWith(showFinishButtonResult: check));
    if (isLoading) setLoading(false);
  }

  Future<bool> _showFinishButton() async {
    final familyMembers =
        getFamilyMembersWithPendencesStore.state.familyMembers;
    for (int i = 0; i < familyMembers.length + 1; i++) {
      if (i == 0) {
        await getProofsWithPendencesStore(
          FamilyGroupParams(
            scholarshipReviewId: state.scholarshipReviewId,
          ),
        );
      } else {
        await getProofsWithPendencesStore(
          FamilyMemberParams(
            familyMemberId: familyMembers[i - 1].id,
            scholarshipReviewId: state.scholarshipReviewId,
          ),
        );
      }
      if (getProofsWithPendencesStore.error != null) {
        return false;
      } else if (missingSendDocuments) {
        return false;
      }
    }
    return true;
  }

  bool get missingSendDocuments => getProofsWithPendencesStore.state.proofs.any(
      (element) => element.scholarshipProofDocuments.any(
          (element) => !element.scholarshipProofDocumentReviews.first.resend));

  void finishSendingDocuments() {
    if (state.scholarshipReviewId.isEmpty) return;
    finishSendingDocumentsStore(
      finish_sending_documents_with_pendences.Params(
        scholarshipId: state.scholarshipWithPendencesDto.id,
        scholarshipReviewId: state.scholarshipReviewId,
      ),
    );
  }
}
