class Params {
  final String scholarshipId;
  final bool acceptedTerms;
  final String password;

  const Params({
    required this.scholarshipId,
    this.acceptedTerms = false,
    required this.password,
  });
}
