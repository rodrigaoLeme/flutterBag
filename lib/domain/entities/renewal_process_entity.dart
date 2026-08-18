class RenewalProcessEntity {
  final String administrativeRegion;
  final String notice;
  final String level;
  final String scholarshipType;
  final List<String> candidates;

  const RenewalProcessEntity({
    required this.administrativeRegion,
    required this.notice,
    required this.level,
    required this.scholarshipType,
    required this.candidates,
  });
}
