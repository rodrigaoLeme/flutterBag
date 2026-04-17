import '../../../domain/usecases/usecases.dart';
import '../../../ui/modules/edit_profile/edit_profile_presenter.dart';
import '../../mixins/mixins.dart';

class StreamEditProfilePresenter
    with SessionManager, LoadingManager, NavigationManager, UIErrorManager
    implements EditProfilePresenter {
  final LoadEditProfile loadEditProfile;

  StreamEditProfilePresenter({
    required this.loadEditProfile,
  });

  @override
  Future<void> loadData() async {}
}
