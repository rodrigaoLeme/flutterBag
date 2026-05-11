import 'package:flutter/material.dart';

import '../../../../presentation/presenters/splash/stream_splash_presenter.dart';
import '../../../../ui/modules/splash/splash_page.dart';
import '../../../../ui/modules/splash/splash_presenter.dart';
import '../../http/http_factories.dart';
import '../../usecases/auth/auth_usecase_factories.dart';

SplashPresenter makeSplashPresenter() => StreamSplashPresenter(
      secureStorage: makeSecureStorage(),
      loadAccountUsecase: makeRemoteLoadAccount(),
    );

Widget makeSplashPage() => SplashPage(presenter: makeSplashPresenter());
