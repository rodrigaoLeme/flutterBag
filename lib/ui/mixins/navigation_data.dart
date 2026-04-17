class NavigationData {
  final String route;
  final bool clear;
  final dynamic arguments;

  NavigationData({
    required this.route,
    required this.clear,
    this.arguments,
  });
}
