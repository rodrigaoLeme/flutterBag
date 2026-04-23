import 'package:flutter/material.dart';

import '../../../../ui/modules/auth/login_page.dart';
import '../../../../ui/modules/auth/create_account_page.dart';
import '../../../../ui/modules/auth/forgot_password_page.dart';
import 'auth_presenter_factory.dart';

Widget makeLoginPage() => LoginPage(presenter: makeLoginPresenter());

Widget makeCreateAccountPage() =>
    CreateAccountPage(presenter: makeCreateAccountPresenter());

Widget makeForgotPasswordPage() =>
    ForgotPasswordPage(presenter: makeForgotPasswordPresenter());
