import 'package:flutter/material.dart';

import '../../../../ui/modules/onboarding/onboarding_page.dart';
import 'onboarding_presenter_factory.dart';

Widget makeOnboardingPage() => OnboardingPage(
      presenter: makeOnboardingPresenter(),
    );
