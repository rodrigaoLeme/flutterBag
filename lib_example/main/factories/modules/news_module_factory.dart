import 'package:flutter_modular/flutter_modular.dart';

import '../../routes/core_module.dart';
import '../../routes/routes_app.dart';
import '../pages/pages.dart';

class NewsModule extends Module {
  @override
  List<Module> get imports => [
        CoreModule(),
      ];

  @override
  void binds(i) {}

  @override
  void routes(r) {
    r.child(
      Routes.news,
      child: (_) => makeNewsPage(),
      transition: TransitionType.fadeIn,
    );
  }
}
