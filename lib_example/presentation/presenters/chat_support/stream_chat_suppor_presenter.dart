import '../../../domain/usecases/usecases.dart';
import '../../../ui/modules/chat_support/chat_support_presenter.dart';
import '../../mixins/mixins.dart';

class StreamChatSupporPresenter
    with SessionManager, LoadingManager, NavigationManager, UIErrorManager
    implements ChatSupportPresenter {
  LoadChatSupport loadChatSupport;

  StreamChatSupporPresenter({
    required this.loadChatSupport,
  });

  @override
  Future<void> loadData() async {}
}
