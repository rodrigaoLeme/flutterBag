import 'params.dart';
import 'result_typedef.dart';

abstract class LoginWithIdUsecase {
  LoginWithIdResult call(LoginWithIdParams params);
}
