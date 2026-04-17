import '../../../../data/cache/cache.dart';
import '../../../../infra/cache/storage_adapters.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

SecureStorage makeSecureStorageUsecase() => FlutterSecureStorageAdapter(
      const FlutterSecureStorage(
        aOptions: AndroidOptions(encryptedSharedPreferences: true),
      ),
    );
