import 'cache.dart';

/// Aqui a gente gerencia os drafts locais de cada etapa do form
/// a chave para a etapa 1 é o processPeriodId pq ainda não tem scholarshipId
/// já para as etapas seguintes, usamos o SchorlashipID
class EnrollmentDraftStorage {
  final LocalStorage _storage;

  const EnrollmentDraftStorage(this._storage);

  String _step1Key(String processPeriodId) => 'draft_${processPeriodId}_step_1';

  String _stepKey(String scholarshipId, int step) =>
      'draft_${scholarshipId}_step_$step';

  // Etaoa 1
  Future<void> saveStep1(
      String processPeriodId, Map<String, dynamic> data) async {
    await _storage.save(key: _step1Key(processPeriodId), value: data);
  }

  Future<Map<String, dynamic>?> loadStep1(String processPeriodId) async {
    return _storage.fetch(key: _step1Key(processPeriodId));
  }

  Future<void> deleteStep1(String processPeriodId) async {
    await _storage.delete(key: _step1Key(processPeriodId));
  }

  // Etapas 2 em diante
  Future<void> saveStep(
      String scholarshipId, int step, Map<String, dynamic> data) async {
    await _storage.save(key: _stepKey(scholarshipId, step), value: data);
  }

  Future<Map<String, dynamic>?> loadStep(String scholarshipId, int step) async {
    return _storage.fetch(key: _stepKey(scholarshipId, step));
  }

  Future<void> deleteStep(String scholarshipId, int step) async {
    await _storage.delete(key: _stepKey(scholarshipId, step));
  }

  Future<void> clearAll(String processPeriodId, String scholarshipId) async {
    await deleteStep1(processPeriodId);
    for (int step = 2; step <= 5; step++) {
      await deleteStep(scholarshipId, step);
    }
  }
}
