import '../../entities/chat_support/chat_support_entity.dart';

abstract class LoadChatSupport {
  Future<ChatSupportEntity> load();
}
