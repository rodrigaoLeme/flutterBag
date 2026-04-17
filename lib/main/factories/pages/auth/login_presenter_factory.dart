import '../../../../presentation/presenters/auth/stream_login_presenter.dart';
import '../../../../ui/modules/auth/login_presenter.dart';
import '../../usecases/account/authentication_factory.dart';
import '../../usecases/account/save_current_account_factory.dart';

LoginPresenter makeLoginPresenter() => StreamLoginPresenter(
      authentication: makeRemoteAuthentication(),
      saveCurrentAccount: makeLocalSaveCurrentAccount(),
    );
