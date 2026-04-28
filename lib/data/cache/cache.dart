abstract class SecureStorage {
  Future<void> save({required String key, required String value});
  Future<String?> fetch({required String key});
  Future<void> delete({required String key});
  Future<void> clean();
}

abstract class LocalStorage {
  Future<void> save({required String key, required Map<String, dynamic> value});
  Future<Map<String, dynamic>?> fetch({required String key});
  Future<void> delete({required String key});
}

class StorageKeys {
  StorageKeys._();
  static const accessToken = 'access_token';
  static const refreshToken = 'refresh_token';
  static const refreshTokenExpiryTime = 'refresh_token_expiry_time';
  static const hasSeenTutorial = 'has_seen_tutorial';
}
