import 'package:flutter/material.dart';

import '../../../../ui/modules/accessibility/accessibility_page.dart';
import 'accessibility_presenter_factory.dart';

Widget makeAccessibilityPage() => AccessibilityPage(
      presenter: makeAccessibilityPresenter(),
    );
