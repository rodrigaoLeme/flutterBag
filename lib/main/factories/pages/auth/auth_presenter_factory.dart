import '../../../../presentation/presenters/auth/stream_create_account_presenter.dart';
import '../../../../presentation/presenters/auth/stream_forgot_password_presenter.dart';
import '../../../../presentation/presenters/auth/stream_login_presenter.dart';
import '../../../../ui/modules/auth/auth_presenter.dart';
import '../../usecases/auth/auth_usecase_factories.dart';

LoginPresenter makeLoginPresenter() => StreamLoginPresenter(
      loginUsecase: makeRemoteLogin(),
    );

CreateAccountPresenter makeCreateAccountPresenter() =>
    StreamCreateAccountPresenter(
      createAccountUsecase: makeRemoteCreateAccount(),
    );

ForgotPasswordPresenter makeForgotPasswordPresenter() =>
    StreamForgotPasswordPresenter(
      forgotPasswordUsecase: makeRemoteForgotPassword(),
    );
