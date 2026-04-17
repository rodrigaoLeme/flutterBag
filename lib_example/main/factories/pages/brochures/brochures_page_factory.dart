import 'package:flutter/material.dart';

import '../../../../ui/modules/brochures/brochures_page.dart';
import 'brochures_presenter_factory.dart';

Widget makeBrochuresPage() =>
    BrochuresPage(presenter: makeBrochuresPresenter());
