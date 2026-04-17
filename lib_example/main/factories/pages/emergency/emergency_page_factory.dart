import 'package:flutter/material.dart';

import '../../../../ui/modules/emergency/emergency_page.dart';
import 'emergency_presenter_factory.dart';

Widget makeEmergencyPage() => EmergencyPage(
      presenter: makeEmergencyPresenter(),
    );
