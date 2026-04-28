import '../../../domain/entities/notice_entity.dart';

abstract class NoticesTermsPresenter {
  Stream<List<NoticeEntity>> get noticesStream;

  Future<void> fetchNotices({
    required String year,
    required String city,
    required String unit,
  });

  void clearNotices();

  void dispose();
}
