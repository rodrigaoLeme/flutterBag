import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../data/cache/cache.dart';

class SharedPreferencesStorageAdapter implements SharedPreferencesStorage {
  final FlutterSecureStorage _storage;

  SharedPreferencesStorageAdapter()
      : _storage = const FlutterSecureStorage(
          aOptions: AndroidOptions(),
        );

  @override
  Future<void> save({required String key, required String value}) async {
    await _storage.write(key: key, value: value);
  }

  @override
  Future<void> clean() async {
    await _storage.deleteAll();
  }

  @override
  Future<String?> fetch(String key) async {
    return _storage.read(key: key);
  }
}
