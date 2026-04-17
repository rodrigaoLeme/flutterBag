import '../../../ui/modules/user_id/user_id_presenter.dart';
import '../../mixins/mixins.dart';

class StreamUserIdPresenter
    with SessionManager, LoadingManager, NavigationManager, UIErrorManager
    implements UserIdPresenter {
  @override
  Future<void> loadData() async {}
}
