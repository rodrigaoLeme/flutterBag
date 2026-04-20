abstract class Params {
  final String scholarshipReviewId;
  const Params({required this.scholarshipReviewId});
}

class FamilyGroupParams extends Params {
  const FamilyGroupParams({required super.scholarshipReviewId});
}

const proofReferenceParamsEmpty = FamilyGroupParams(scholarshipReviewId: '');

class FamilyMemberParams extends Params {
  final String familyMemberId;
  const FamilyMemberParams({required super.scholarshipReviewId, required this.familyMemberId});
}

const familyMemberParamsEmpty = FamilyMemberParams(scholarshipReviewId: '', familyMemberId: '');
