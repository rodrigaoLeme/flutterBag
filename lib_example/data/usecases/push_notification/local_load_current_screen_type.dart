import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';

import '../../../domain/helpers/domain_error.dart';
import '../../../domain/helpers/secure_storage_key.dart';
import '../../../domain/usecases/push_notification/load_current_screen_type.dart';
import '../../cache/shared_preferences_storage.dart';

class LocalLoadCurrentScreenType implements LoadCurrentScreenType {
  final SharedPreferencesStorage sharedPreferencesStorage;

  LocalLoadCurrentScreenType({
    required this.sharedPreferencesStorage,
  });

  @override
  Future<RemoteMessage?> load() async {
    try {
      final data = await sharedPreferencesStorage
          .fetch(SecureStorageKey.notificationType);
      if (data == null) throw DomainError.unexpected;

      return RemoteMessage.fromMap(jsonDecode(data));
    } catch (_) {
      throw DomainError.unexpected;
    }
  }
}
