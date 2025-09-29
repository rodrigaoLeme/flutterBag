import '../../../../../core/constants/review_type.dart';
import '../../../../../core/constants/scholarship_status.dart';

class Entity {
  final ScholarshipStatus scholarshipStatus;
  final bool digitalProcess;
  final int reviewStatus;
  final int completedStep;
  final String id;
  final ReviewType lastReviewType;
  final List<ScholarshipReview> scholarshipReviews;
  final String userId;
  final String processPeriodId;
  final int declassificationType;
  const Entity({
    required this.scholarshipStatus,
    required this.digitalProcess,
    this.reviewStatus = -1,
    required this.completedStep,
    required this.id,
    required this.lastReviewType,
    required this.scholarshipReviews,
    required this.userId,
    required this.processPeriodId,
    required this.declassificationType,
  });

  factory Entity.empty() => const Entity(
        scholarshipStatus: ScholarshipStatus.notFinished,
        digitalProcess: false,
        reviewStatus: -1,
        completedStep: -1,
        id: '',
        lastReviewType: ReviewType.attendant,
        scholarshipReviews: [],
        userId: '',
        processPeriodId: '',
        declassificationType: 0,
      );
}

class ScholarshipReview {
  final String dateTime;
  final ReviewType reviewType;

  const ScholarshipReview({required this.dateTime, required this.reviewType});
}
