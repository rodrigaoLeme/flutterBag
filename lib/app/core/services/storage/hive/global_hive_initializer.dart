import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

class GlobalHiveInitializer {
  final completer = Completer<void>();

  Future<void> init() async {
    try {
      await Hive.initFlutter();
      completer.complete();
    } catch (e) {
      debugPrint('Erro ao inicializar Hive: $e');
      try {
        await Hive.deleteFromDisk();
        await Hive.initFlutter();
        completer.complete();
      } catch (e2) {
        debugPrint('Erro crítico ao inicializar Hive: $e2');
        completer.completeError(e2);
      }
    }
  }
}
