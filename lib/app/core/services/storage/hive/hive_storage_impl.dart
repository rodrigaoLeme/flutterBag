import 'dart:async';

import 'package:hive_flutter/hive_flutter.dart';

import 'global_hive_initializer.dart';
import '../interface.dart';
import '../storage_type.dart';

class HiveBoxStorage<T> implements Storage<T> {
  final GlobalHiveInitializer _hiveInitializer;
  final completer = Completer<Box<T>>();

  @override
  final StorageType storageType;

  HiveBoxStorage(this._hiveInitializer, this.storageType);

  @override
  Future<void> init() async {
    await _hiveInitializer.completer.future;
    final box = await Hive.openBox<T>(storageType.toString());
    completer.complete(box);
  }

  @override
  Future<T?> get(String key) async {
    final box = await completer.future;
    final value = box.get(key);
    return value;
  }

  @override
  Future<void> put(String key, T value) async {
    final box = await completer.future;
    await box.put(key, value);
  }
}
