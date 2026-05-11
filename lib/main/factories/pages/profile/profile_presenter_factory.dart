import '../../../../presentation/presenters/profile/stream_profile_presenter.dart';
import '../../../../ui/modules/profile/profile_presenter.dart';
import '../../usecases/account/update_contact_info_factory.dart';
import '../../usecases/auth/auth_usecase_factories.dart';

ProfilePresenter makeProfilePresenter() => StreamProfilePresenter(
      updateContactInfoUsecase: makeRemoteUpdateContactInfo(),
      logoutUsecase: makeRemoteLogout(),
    );
