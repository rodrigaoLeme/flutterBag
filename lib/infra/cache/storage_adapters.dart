import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';

import '../../data/cache/cache.dart';

class FlutterSecureStorageAdapter implements SecureStorage {
  final FlutterSecureStorage _storage;

  const FlutterSecureStorageAdapter(this._storage);

  @override
  Future<void> save({required String key, required String value}) async {
    await _storage.write(key: key, value: value);
  }

  @override
  Future<String?> fetch({required String key}) async {
    return _storage.read(key: key);
  }

  @override
  Future<void> delete({required String key}) async {
    await _storage.delete(key: key);
  }

  @override
  Future<void> clean() async {
    await _storage.deleteAll();
  }
}

class JsonFileStorageAdapter implements LocalStorage {
  static const _folder = 'drafts';

  Future<File> _file(String key) async {
    final dir = await getApplicationDocumentsDirectory();
    final draftsDir = Directory('${dir.path}/$_folder');
    if (!await draftsDir.exists()) {
      await draftsDir.create(recursive: true);
    }
    return File('${draftsDir.path}/$key.json');
  }

  @override
  Future<void> save({
    required String key,
    required Map<String, dynamic> value,
  }) async {
    final file = await _file(key);
    await file.writeAsString(jsonEncode(value));
  }

  @override
  Future<Map<String, dynamic>?> fetch({required String key}) async {
    try {
      final file = await _file(key);
      if (!await file.exists()) return null;
      final content = await file.readAsString();
      return jsonDecode(content) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> delete({required String key}) async {
    final file = await _file(key);
    if (await file.exists()) await file.delete();
  }
}
