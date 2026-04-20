import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../interface.dart';
import '../storage_type.dart';
import 'global_hive_initializer.dart';

class HiveBoxStorage<T> implements Storage<T> {
  final GlobalHiveInitializer _hiveInitializer;
  final completer = Completer<Box<T>>();

  @override
  final StorageType storageType;

  HiveBoxStorage(this._hiveInitializer, this.storageType);

  @override
  Future<void> init() async {
    try {
      await _hiveInitializer.completer.future;
      final box = await Hive.openBox<T>(storageType.toString());
      completer.complete(box);
    } catch (e) {
      debugPrint('Erro ao abrir box ${storageType.toString()}: $e');
      try {
        await Hive.deleteBoxFromDisk(storageType.toString());
        final box = await Hive.openBox<T>(storageType.toString());
        completer.complete(box);
      } catch (e2) {
        debugPrint('Erro crítico ao abrir box: $e2');
        completer.completeError(e2);
      }
    }
  }

  @override
  Future<T?> get(String key) async {
    try {
      final box = await completer.future;
      final value = box.get(key);
      return value;
    } catch (e) {
      debugPrint('Erro ao ler do Hive: $e');
      return null;
    }
  }

  @override
  Future<void> put(String key, T value) async {
    try {
      final box = await completer.future;
      await box.put(key, value);
    } catch (e) {
      debugPrint('Erro ao escrever no Hive: $e');
    }
  }
}
