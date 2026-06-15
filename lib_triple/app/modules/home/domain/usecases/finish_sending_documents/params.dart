class Params {
  final String scholarshipId;
  final bool acceptTerm;
  final String password;

  const Params({
    required this.scholarshipId,
    this.acceptTerm = false,
    required this.password,
  });
}
