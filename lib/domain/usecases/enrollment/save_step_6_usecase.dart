class SaveStep6Params {
  final String scholarshipId;
  final String password;

  const SaveStep6Params({
    required this.scholarshipId,
    required this.password,
  });
}

abstract class SaveStep6Usecase {
  Future<void> save(SaveStep6Params params);
}
