import 'package:flutter/material.dart';

import '../../../../ui/modules/modules.dart';
import 'edit_profile_presenter_factory.dart';

Widget makeEditProfilePage() =>
    EditProfilePage(presenter: makeEditProfilePresenter());
