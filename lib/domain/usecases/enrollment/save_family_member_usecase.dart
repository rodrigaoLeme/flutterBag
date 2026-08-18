import '../../entities/family_member_entity.dart';

class SaveFamilyMemberParams {
  final String scholarshipId;
  final FamilyMemberEntity member;

  const SaveFamilyMemberParams({
    required this.scholarshipId,
    required this.member,
  });
}

abstract class SaveFamilyMemberUsecase {
  Future<String> save(SaveFamilyMemberParams params);
}
