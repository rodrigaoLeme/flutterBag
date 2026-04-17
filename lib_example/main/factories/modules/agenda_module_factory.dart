import 'package:flutter_modular/flutter_modular.dart';

import '../../routes/core_module.dart';
import '../../routes/routes_app.dart';
import '../pages/agenda/agenda_page_factory.dart';
import '../pages/pages.dart';

class AgendaModule extends Module {
  @override
  List<Module> get imports => [
        CoreModule(),
      ];

  @override
  void binds(i) {}

  @override
  void routes(r) {
    r.child(
      Routes.eventDetails,
      child: (_) => makeEventDetailsPage(),
      transition: TransitionType.fadeIn,
    );
    r.child(
      Routes.agenda,
      child: (_) => makeAgendaPage(),
      transition: TransitionType.fadeIn,
    );
  }
}
