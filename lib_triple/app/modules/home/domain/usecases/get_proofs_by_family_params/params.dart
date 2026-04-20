abstract class Params {
  final String scholarshipId;
  const Params({required this.scholarshipId});
}

class FamilyGroupParams extends Params {
  const FamilyGroupParams({required super.scholarshipId});

  factory FamilyGroupParams.empty() =>
      const FamilyGroupParams(scholarshipId: '');
}

class FamilyMemberParams extends Params {
  final String familyMemberId;
  const FamilyMemberParams(
      {required super.scholarshipId, required this.familyMemberId});

  factory FamilyMemberParams.empty() =>
      const FamilyMemberParams(scholarshipId: '', familyMemberId: '');
}
