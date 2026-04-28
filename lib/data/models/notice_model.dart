import '../../domain/entities/notice_entity.dart';

class NoticeModel extends NoticeEntity {
  NoticeModel({
    required super.id,
    required super.name,
    required super.publishedAt,
    required super.modality,
    required super.enrollmentType,
    super.additiveTerms,
  });

  factory NoticeModel.fromJson(Map<String, dynamic> json) {
    return NoticeModel(
      id: json['id'] as String,
      name: json['name'] as String,
      publishedAt: DateTime.parse(json['publishedAt'] as String),
      modality: json['modality'] as String,
      enrollmentType: json['enrollmentType'] as String,
      additiveTerms: (json['additiveTerms'] as List<dynamic>?)
          ?.map((term) =>
              AdditiveTermModel.fromJson(term as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'publishedAt': publishedAt.toIso8601String(),
        'modality': modality,
        'enrollmentType': enrollmentType,
        'additiveTerms': additiveTerms
            ?.map((term) => (term as AdditiveTermModel).toJson())
            .toList(),
      };
}

class AdditiveTermModel extends AdditiveTermEntity {
  AdditiveTermModel({
    required super.id,
    required super.name,
    required super.publishedAt,
    required super.modality,
    required super.enrollmentType,
    required super.noticeId,
  });

  factory AdditiveTermModel.fromJson(Map<String, dynamic> json) {
    return AdditiveTermModel(
      id: json['id'] as String,
      name: json['name'] as String,
      publishedAt: DateTime.parse(json['publishedAt'] as String),
      modality: json['modality'] as String,
      enrollmentType: json['enrollmentType'] as String,
      noticeId: json['noticeId'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'publishedAt': publishedAt.toIso8601String(),
        'modality': modality,
        'enrollmentType': enrollmentType,
        'noticeId': noticeId,
      };
}
