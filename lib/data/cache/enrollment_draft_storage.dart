import 'cache.dart';

/// Aqui a gente gerencia os drafts locais de cada etapa do form
class EnrollmentDraftStorage {
  final LocalStorage _storage;

  const EnrollmentDraftStorage(this._storage);

  String _key(String userId, String processPeriodId) =>
      'enrollment_${userId}_$processPeriodId';

  Future<void> save({
    required String userId,
    required String processPeriodId,
    required Map<String, dynamic> data,
  }) async {
    await _storage.save(key: _key(userId, processPeriodId), value: data);
  }

  Future<Map<String, dynamic>?> load({
    required String userId,
    required String processPeriodId,
  }) async {
    return _storage.fetch(key: _key(userId, processPeriodId));
  }

  Future<void> delete({
    required String userId,
    required String processPeriodId,
  }) async {
    await _storage.delete(key: _key(userId, processPeriodId));
  }
}
