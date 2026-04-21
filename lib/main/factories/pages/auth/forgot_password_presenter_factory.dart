import '../../../../presentation/presenters/auth/stream_forgot_password_presenter.dart';
import '../../../../ui/modules/auth/forgot_password_presenter.dart';
import '../../usecases/account/forgot_password_factory.dart';

ForgotPasswordPresenter makeForgotPasswordPresenter() =>
    StreamForgotPasswordPresenter(
      forgotPassword: makeRemoteForgotPassword(),
    );
