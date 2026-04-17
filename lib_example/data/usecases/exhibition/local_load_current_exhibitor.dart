import 'dart:convert';

import '../../../domain/entities/entities.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/exhibition/load_current_exhibitor.dart';
import '../../cache/cache.dart';
import '../../models/exhibition/exhibition.dart';

class LocalLoadCurrentExhibitor implements LoadCurrentExhibitor {
  final SharedPreferencesStorage sharedPreferencesStorage;

  LocalLoadCurrentExhibitor({
    required this.sharedPreferencesStorage,
  });

  @override
  Future<ExhibitionEntity?> load({
    required LoadCurrentExhibitorParams params,
  }) async {
    try {
      final key = '${SecureStorageKey.favoriteExhibitor}_${params.eventId}';
      final data = await sharedPreferencesStorage.fetch(key);
      if (data == null) throw DomainError.expiredSession;
      final model = RemoteExhibitionModel.fromJson(jsonDecode(data)).toEntity();
      return model;
    } catch (error) {
      return null;
    }
  }
}
