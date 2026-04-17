import '../../../../presentation/presenters/presenters.dart';
import '../../../../ui/modules/edit_profile/edit_profile_presenter.dart';
import '../../usecases/usecases.dart';

EditProfilePresenter makeEditProfilePresenter() =>
    StreamEditProfilePresenter(loadEditProfile: makeRemoteLoadEditProfile());
