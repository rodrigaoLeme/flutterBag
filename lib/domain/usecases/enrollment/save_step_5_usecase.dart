class SaveStep5Params {
  final String scholarshipId;

  const SaveStep5Params({required this.scholarshipId});
}

abstract class SaveStep5Usecase {
  Future<void> save(SaveStep5Params params);
}
