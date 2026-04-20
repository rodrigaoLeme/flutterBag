import '../../../entities/logged_user_v2.dart';
import '../../session/presenter/session_store.dart';

class AuthProxyStore {
  final SessionStore _sessionStore;

  Future<void> storeNewSession(LoggedUser loggedUser) {
    return _sessionStore.storeNewSession(loggedUser);
  }

  AuthProxyStore(this._sessionStore);
}
