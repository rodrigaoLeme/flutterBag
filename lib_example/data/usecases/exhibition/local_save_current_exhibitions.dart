import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/exhibition/save_current_exhibition.dart';
import '../../cache/cache.dart';

class LocalSaveCurrentExhibitions implements SaveCurrentExhibition {
  final SharedPreferencesStorage sharedPreferencesStorage;

  LocalSaveCurrentExhibitions({
    required this.sharedPreferencesStorage,
  });

  @override
  Future<void> save({required SaveCurrentExhibitionParams params}) async {
    try {
      final key = '${SecureStorageKey.favoriteExhibitor}_${params.eventId}';
      await sharedPreferencesStorage.save(
        key: key,
        value: params.data,
      );
    } catch (error) {
      throw DomainError.unexpected;
    }
  }
}
