import 'package:flutter_modular/flutter_modular.dart';

import 'factories/modules/agenda_module_factory.dart';
import 'factories/modules/auth_module_factory.dart';
import 'factories/modules/main_module_factory.dart';
import 'factories/modules/news_module_factory.dart';

class AppModule extends Module {
  @override
  void binds(i) {}

  @override
  void routes(r) {
    r.module(
      '/',
      module: AuthModule(),
      transition: TransitionType.fadeIn,
    );
    r.module(
      '/',
      module: AgendaModule(),
      transition: TransitionType.fadeIn,
    );
    r.module(
      '/',
      module: NewsModule(),
      transition: TransitionType.fadeIn,
    );
    r.module(
      '/',
      module: MainModule(),
      transition: TransitionType.fadeIn,
    );
  }
}
