import '../../../../presentation/presenters/presenters.dart';
import '../../../../ui/modules/chat_support/chat_support_presenter.dart';
import '../../usecases/usecases.dart';

ChatSupportPresenter makeChatSupportPresenter() =>
    StreamChatSupporPresenter(loadChatSupport: makeRemoteLoadChatSupport());
