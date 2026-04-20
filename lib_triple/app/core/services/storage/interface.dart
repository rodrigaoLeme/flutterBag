import 'storage_type.dart';

abstract class Storage<T> {
  final StorageType storageType;

  const Storage(this.storageType);

  Future<void> init();
  Future<T?> get(String key);
  Future<void> put(String key, T value);
}
