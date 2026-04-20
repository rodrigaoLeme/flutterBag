import 'package:flutter/foundation.dart';

import '../../ui/mixins/mixins.dart';

mixin NavigationManager {
  final ValueNotifier<NavigationData?> _navigateToController =
      ValueNotifier<NavigationData?>(null);

  set navigateTo(NavigationData value) => _navigateToController.value = value;
  ValueNotifier<NavigationData?> get navigateToListener =>
      _navigateToController;
}
