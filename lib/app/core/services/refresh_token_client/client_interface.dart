import 'package:either_dart/either.dart';

import 'client_exception.dart';
import 'client_response.dart';

abstract class RefreshTokenClient {
  Future<Either<RefreshTokenClientException, RefreshTokenClientResponse>> getNewSession(String path, dynamic data);
}
