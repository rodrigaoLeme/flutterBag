import 'dart:async';

import 'package:hive_flutter/adapters.dart';

class GlobalHiveInitializer {
  final completer = Completer<void>();

  Future<void> init() async {
    await Hive.initFlutter();
    completer.complete();
  }
}
