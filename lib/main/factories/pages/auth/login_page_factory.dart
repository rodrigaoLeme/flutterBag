import 'package:flutter/material.dart';

import '../../../../ui/modules/auth/login_page.dart';
import 'login_presenter_factory.dart';

Widget makeLoginPage() => LoginPage(presenter: makeLoginPresenter());
