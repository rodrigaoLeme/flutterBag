import 'dart:async';

import '../../../ui/modules/profile/profile_presenter.dart';
import '../../mixins/mixins.dart';

class StreamProfilePresenter
    with SessionManager, LoadingManager, NavigationManager, UIErrorManager
    implements ProfilePresenter {
  Future<void> loadData() async {}

  @override
  Future<void> checkSession() {
    throw UnimplementedError();
  }

  @override
  void dispose() {}

  final _navigationController = StreamController<String?>.broadcast();
  @override
  Stream<String?> get navigationRouteStream =>
      throw _navigationController.stream;
}
