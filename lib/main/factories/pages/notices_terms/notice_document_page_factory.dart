import '../../../../presentation/presenters/notices_terms/stream_notice_document_presenter.dart';
import '../../../../ui/modules/notices_terms/notice_document_presenter.dart';
import '../../usecases/notices/load_announcement_file_factory.dart';

NoticeDocumentPresenter makeNoticeDocumentPresenter() =>
    StreamNoticeDocumentPresenter(
      loadAnnouncementFileUsecase: makeRemoteLoadAnnouncementFile(),
    );
