import 'package:flutter/material.dart';

import '../../../../ui/modules/translation/translation_page.dart';
import 'translation_presenter_factory.dart';

Widget makeTranslationPage() => TranslationPage(
      presenter: makeTranslationPresenter(),
    );
