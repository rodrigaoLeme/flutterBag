import '../../../../presentation/presenters/auth/stream_account_not_confirmed_presenter.dart';
import '../../../../presentation/presenters/auth/stream_create_account_presenter.dart';
import '../../../../presentation/presenters/auth/stream_forgot_password_presenter.dart';
import '../../../../presentation/presenters/auth/stream_login_presenter.dart';
import '../../../../ui/modules/auth/auth_presenter.dart';
import '../../http/http_factories.dart';
import '../../usecases/account/update_contact_info_factory.dart';
import '../../usecases/auth/auth_usecase_factories.dart';

LoginPresenter makeLoginPresenter() => StreamLoginPresenter(
      loginUsecase: makeRemoteLogin(),
      secureStorage: makeSecureStorage(),
      loadAccountUsecase: makeRemoteLoadAccount(),
    );

AccountNotConfirmedPresenter makeAccountNotConfirmedPresenter() =>
    StreamAccountNotConfirmedPresenter(
      updateContactInfoUsecase: makeRemoteUpdateContactInfo(),
    );

CreateAccountPresenter makeCreateAccountPresenter() =>
    StreamCreateAccountPresenter(
      createAccountUsecase: makeRemoteCreateAccount(),
    );

ForgotPasswordPresenter makeForgotPasswordPresenter() =>
    StreamForgotPasswordPresenter(
      forgotPasswordUsecase: makeRemoteForgotPassword(),
    );
