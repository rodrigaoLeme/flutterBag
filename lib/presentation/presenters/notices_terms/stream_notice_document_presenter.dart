import 'dart:async';

import '../../../domain/usecases/notices/load_announcement_file.dart';
import '../../../infra/repositories/notices/remote_load_announcement_file_usecase.dart';
import '../../../main/i18n/app_i18n.dart';
import '../../../ui/modules/notices_terms/notice_document_presenter.dart';

class StreamNoticeDocumentPresenter implements NoticeDocumentPresenter {
  final LoadAnnouncementFileUsecase loadAnnouncementFileUsecase;

  StreamNoticeDocumentPresenter({required this.loadAnnouncementFileUsecase});

  final _stateController = StreamController<NoticeDocumentState>.broadcast();

  @override
  Stream<NoticeDocumentState> get stateStream => _stateController.stream;

  @override
  Future<void> loadFile(String announcementId) async {
    _emit(NoticeDocumentLoading());

    try {
      final url = await loadAnnouncementFileUsecase
          .load(LoadAnnouncementFileParams(announcementId: announcementId));

      _emit(NoticeDocumentSuccess(url));
    } on LoadAnnouncementFileException catch (e) {
      _emit(NoticeDocumentError(e.message));
    } catch (_) {
      _emit(NoticeDocumentError(AppI18n.current.noticesStreamError));
    }
  }

  void _emit(NoticeDocumentState state) {
    if (!_stateController.isClosed) _stateController.add(state);
  }

  @override
  void dispose() => _stateController.close();
}
