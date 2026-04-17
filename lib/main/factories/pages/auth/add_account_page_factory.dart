import 'package:flutter/material.dart';

import '../../../../ui/modules/auth/add_account_page.dart';
import 'add_account_presenter_factory.dart';

Widget makeAddAccountPage() =>
    AddAccountPage(presenter: makeAddAccountPresenter());
