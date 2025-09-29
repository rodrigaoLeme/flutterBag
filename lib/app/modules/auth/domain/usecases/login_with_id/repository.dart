import 'params.dart';
import 'result_typedef.dart';

abstract class LoginWithIdRepository {
  LoginWithIdResult call(LoginWithIdParams params);
}
