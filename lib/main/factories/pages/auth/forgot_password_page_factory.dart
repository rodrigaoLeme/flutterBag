import 'package:flutter/material.dart';

import '../../../../ui/modules/auth/forgot_password_page.dart';
import 'forgot_password_presenter_factory.dart';

Widget makeForgotPasswordPage() =>
    ForgotPasswordPage(presenter: makeForgotPasswordPresenter());
