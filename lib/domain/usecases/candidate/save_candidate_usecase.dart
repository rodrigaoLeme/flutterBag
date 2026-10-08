class SaveCandidateParams {
  final String scholarshipId;
  final String familyMemberId;
  final String schoolId;
  final String academicCourseId;
  final int legalPersonType;
  final int educationLevel;
  final int scholarshipType;
  final bool completedGraduation;
  final bool currentlyEnrolledInGraduation;
  final bool? highSchoolScholarshipHolder;
  final String? id;

  const SaveCandidateParams({
    required this.scholarshipId,
    required this.familyMemberId,
    required this.schoolId,
    required this.academicCourseId,
    required this.legalPersonType,
    required this.educationLevel,
    required this.scholarshipType,
    required this.completedGraduation,
    required this.currentlyEnrolledInGraduation,
    this.highSchoolScholarshipHolder,
    this.id,
  });
}

abstract class SaveCandidateUsecase {
  Future<String> save(SaveCandidateParams params); // retorna studentId
}

class SaveCandidateException implements Exception {
  final String message;
  const SaveCandidateException(this.message);
}
