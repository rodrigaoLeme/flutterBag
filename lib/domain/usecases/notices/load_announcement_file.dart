class LoadAnnouncementFileParams {
  final String announcementId;
  const LoadAnnouncementFileParams({required this.announcementId});
}

abstract class LoadAnnouncementFileUsecase {
  Future<String> load(LoadAnnouncementFileParams params);
}
