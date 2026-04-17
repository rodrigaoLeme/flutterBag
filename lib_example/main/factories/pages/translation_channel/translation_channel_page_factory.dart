import 'package:flutter/material.dart';

import '../../../../ui/modules/translation_channel/translation_channel_page.dart';
import 'translation_channel_presenter_factory.dart';

Widget makeTranslationChannelPage() => TranslationChannelPage(
      presenter: makeTranslationChannelPresenter(),
    );
