import 'package:flutter_modular/flutter_modular.dart';

import '../../main/routes/routes.dart';

mixin SessionManager {
  void handleSessionExpired(Stream<bool> stream) {
    stream.listen((isExpired) {
      if (isExpired) {
        Modular.to.navigate(Routes.login);
      }
    });
  }
}
