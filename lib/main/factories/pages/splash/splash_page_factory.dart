import 'package:flutter/material.dart';

import '../../../../presentation/presenters/splash/stream_splash_presenter.dart';
import '../../../../ui/modules/splash/splash_page.dart';
import '../../../../ui/modules/splash/splash_presenter.dart';
import '../../http/http_factories.dart';

SplashPresenter makeSplashPresenter() => StreamSplashPresenter(
      secureStorage: makeSecureStorage(),
    );

Widget makeSplashPage() => SplashPage(presenter: makeSplashPresenter());
