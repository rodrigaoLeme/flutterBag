import 'refresh_token_params.dart';
import 'refresh_token_result.dart';

abstract class RefreshTokenUsecase {
  RefreshTokenResult call(RefreshTokenParamsV2 params);
}
