import 'dart:ui';

class Globals {
  static final Globals _instance = Globals._internal();

  factory Globals() => _instance;

  Globals._internal();

  Color? _primaryColor;

  Color get primaryColor => _primaryColor ?? const Color(0xff2F557F);

  set primaryColor(Color value) {
    _primaryColor = value;
  }
}
