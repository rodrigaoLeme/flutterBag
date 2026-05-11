class UpdateContactInfoParams {
  final String email;
  final String mobileNumber;

  const UpdateContactInfoParams({
    required this.email,
    required this.mobileNumber,
  });
}

abstract class UpdateContactInfoUsecase {
  Future<void> update(UpdateContactInfoParams params);
}
