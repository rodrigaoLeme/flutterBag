import 'package:flutter/material.dart';

import '../../../../ui/modules/business/business_page.dart';
import 'business_presenter_factory.dart';

Widget makeBusinessPage() => BusinessPage(presenter: makeBusinessPresenter());
