sealed class NoticeDocumentState {}

class NoticeDocumentInitial extends NoticeDocumentState {}

class NoticeDocumentLoading extends NoticeDocumentState {}

class NoticeDocumentSuccess extends NoticeDocumentState {
  final String url;
  NoticeDocumentSuccess(this.url);
}

class NoticeDocumentError extends NoticeDocumentState {
  final String message;
  NoticeDocumentError(this.message);
}

abstract class NoticeDocumentPresenter {
  Stream<NoticeDocumentState> get stateStream;
  Future<void> loadFile(String announcement);
  void dispose();
}
