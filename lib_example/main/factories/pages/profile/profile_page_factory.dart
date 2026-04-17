import 'package:flutter/material.dart';

import '../../../../ui/modules/modules.dart';
import 'profile_presenter_factory.dart';

Widget makeProfilePage() => ProfilePage(presenter: makeProfilePresenter());
