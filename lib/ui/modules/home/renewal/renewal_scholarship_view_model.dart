import '../../../../domain/entities/available_announcement_entity.dart';

class RenewalScholarshipViewModel {
  final bool isLoading;
  final List<AvailableAnnouncementEntity> announcements;
  final String? errorMessage;

  const RenewalScholarshipViewModel({
    this.isLoading = false,
    this.announcements = const [],
    this.errorMessage,
  });
}
