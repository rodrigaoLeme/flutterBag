import '../../../domain/usecases/usecases.dart';
import '../../../main/routes/routes.dart';
import '../../../ui/mixins/navigation_data.dart';
import '../../../ui/modules/modules.dart';
import '../../mixins/mixins.dart';

class StreamProfilePresenter
    with SessionManager, LoadingManager, NavigationManager, UIErrorManager
    implements ProfilePresenter {
  final LoadProfile loadProfile;

  StreamProfilePresenter({
    required this.loadProfile,
  });

  @override
  Future<void> loadData() async {}

  @override
  void goToEditProfile() {
    navigateTo = NavigationData(route: Routes.editProfile, clear: false);
  }
}
