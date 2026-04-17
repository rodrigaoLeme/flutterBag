import 'dart:async';

class NavigationBarController {
  final _tabIndexController = StreamController<int>.broadcast();
  int _currentTabIndex = 0;

  Stream<int> get tabIndexStream => _tabIndexController.stream;

  void changeTabIndex(int index) {
    _currentTabIndex = index;
    _tabIndexController.sink.add(index);
  }

  int get currentTabIndex => _currentTabIndex;

  void dispose() {
    _tabIndexController.close();
  }
}
