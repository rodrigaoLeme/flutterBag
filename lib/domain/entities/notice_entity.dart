class NoticeEntity {
  final String id;
  final String name;
  final DateTime publishedAt;
  final String modality;
  final String enrollmentType;
  final List<AdditiveTermEntity>? additiveTerms;

  const NoticeEntity({
    required this.id,
    required this.name,
    required this.publishedAt,
    required this.modality,
    required this.enrollmentType,
    this.additiveTerms,
  });
}

class AdditiveTermEntity {
  final String id;
  final String name;
  final DateTime publishedAt;
  final String modality;
  final String enrollmentType;
  final String noticeId;

  const AdditiveTermEntity({
    required this.id,
    required this.name,
    required this.publishedAt,
    required this.modality,
    required this.enrollmentType,
    required this.noticeId,
  });
}
