import '../../../entities/logged_user_v2_payload.dart';
import '../../session/presenter/session_store.dart';

class HomeUserProxyStore {
  final SessionStore _sessionStore;

  LoggedUserPayload get currentUser => LoggedUserPayload.fromLoggedUser(_sessionStore.state.entity);

  Future<void> logout() => _sessionStore.logout();

  HomeUserProxyStore(this._sessionStore);
}
