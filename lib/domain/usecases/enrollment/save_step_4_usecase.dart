import '../../entities/candidate_entity.dart';

class SaveStep4Params {
  final String scholarshipId;
  final List<CandidateEntity> candidates;
  final int? educationLevel;

  const SaveStep4Params({
    required this.scholarshipId,
    required this.candidates,
    this.educationLevel,
  });
}

abstract class SaveStep4Usecase {
  Future<void> save(SaveStep4Params params);
}
