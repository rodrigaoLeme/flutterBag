import 'package:flutter/material.dart';

import '../../../../ui/modules/modules.dart';
import 'news_presenter_factory.dart';

Widget makeNewsPage() => NewsPage(presenter: makeNewsPresenter());
